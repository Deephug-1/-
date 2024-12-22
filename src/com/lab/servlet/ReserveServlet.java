package com.lab.servlet;

import com.lab.entity.Lab;
import com.lab.entity.LabReserve;
import com.lab.entity.Student;
import com.lab.utils.DbUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@WebServlet("/reserve/*")
public class ReserveServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("utf-8");
        resp.setContentType("text/html;charset=utf-8");
        
        String path = req.getPathInfo();
        if ("/list".equals(path)) {
            listReserves(req, resp);
        } else if ("/add".equals(path)) {
            if ("GET".equalsIgnoreCase(req.getMethod())) {
                // 显示预约页面
                showAddPage(req, resp);
            } else {
                // 处理预约请求
                addReserve(req, resp);
            }
        } else if ("/delete".equals(path)) {
            deleteReserve(req, resp);
        }
    }

    private void showAddPage(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int labId = Integer.parseInt(req.getParameter("labId"));
        try (Connection conn = DbUtil.getConnection()) {
            String sql = "SELECT * FROM lab WHERE lab_id = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, labId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Lab lab = new Lab();
                lab.setLabId(rs.getInt("lab_id"));
                lab.setLabName(rs.getString("lab_name"));
                lab.setEnableReserveNum(rs.getInt("enable_reserve_num"));
                lab.setReservedNum(rs.getInt("reserved_num"));
                
                req.setAttribute("lab", lab);
                req.getRequestDispatcher("/reserveAdd.jsp").forward(req, resp);
            } else {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "实验室不存在");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void addReserve(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            Student user = (Student) req.getSession().getAttribute("user");
            int labId = Integer.parseInt(req.getParameter("labId"));
            String reserveTimeStr = req.getParameter("reserveTime");
            
            // 将HTML5 datetime-local格式转换为数据库格式
            String formattedDateTime = reserveTimeStr.replace('T', ' ') + ":00";
            Timestamp reserveTime = Timestamp.valueOf(formattedDateTime);
            
            try (Connection conn = DbUtil.getConnection()) {
                // 检查实验室是否还有可预约名额
                String checkSql = "SELECT * FROM lab WHERE lab_id = ? AND enable_reserve_num > reserved_num";
                PreparedStatement checkStmt = conn.prepareStatement(checkSql);
                checkStmt.setInt(1, labId);
                ResultSet rs = checkStmt.executeQuery();
                
                if (!rs.next()) {
                    req.setAttribute("error", "该实验室预约名额已满");
                    showAddPage(req, resp);
                    return;
                }
                
                // 开始事务
                conn.setAutoCommit(false);
                try {
                    // 插入预约记录
                    String insertSql = "INSERT INTO lab_reserve (lab_id, lab_name, student_id, student_name, reserve_num, tel, reserve_time) " +
                            "VALUES (?, (SELECT lab_name FROM lab WHERE lab_id = ?), ?, ?, ?, ?, ?)";
                    PreparedStatement pstmt = conn.prepareStatement(insertSql);
                    pstmt.setInt(1, labId);
                    pstmt.setInt(2, labId);
                    pstmt.setInt(3, user.getStudentId());
                    pstmt.setString(4, user.getStudentName());
                    pstmt.setString(5, UUID.randomUUID().toString().substring(0, 8));
                    pstmt.setString(6, user.getTel());
                    pstmt.setTimestamp(7, reserveTime);
                    
                    // 更新实验室已预约人数
                    String updateSql = "UPDATE lab SET reserved_num = reserved_num + 1 WHERE lab_id = ?";
                    PreparedStatement updateStmt = conn.prepareStatement(updateSql);
                    updateStmt.setInt(1, labId);
                    
                    pstmt.executeUpdate();
                    updateStmt.executeUpdate();
                    
                    conn.commit();
                    resp.sendRedirect(req.getContextPath() + "/reserve/list");
                } catch (SQLException e) {
                    conn.rollback();
                    e.printStackTrace();
                    req.setAttribute("error", "预约失败");
                    showAddPage(req, resp);
                }
            }
        } catch (IllegalArgumentException e) {
            req.setAttribute("error", "预约时间格式不正确");
            showAddPage(req, resp);
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "数据库操作失败");
            showAddPage(req, resp);
        }
    }

    private void listReserves(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try (Connection conn = DbUtil.getConnection()) {
            int page = 1;
            int pageSize = 5;
            String pageStr = req.getParameter("page");
            
            if (pageStr != null && !pageStr.isEmpty()) {
                page = Integer.parseInt(pageStr);
            }
            
            // 获取当前用户
            Student user = (Student) req.getSession().getAttribute("user");
            
            // 构建SQL语句
            StringBuilder sql = new StringBuilder("SELECT * FROM lab_reserve");
            // 如果不是管理员，只显示自己的预约
            if (user.getRole() != 1) {
                sql.append(" WHERE student_id = ?");
            }
            sql.append(" ORDER BY create_time DESC LIMIT ?, ?");
            
            // 获取总记录数
            String countSql = "SELECT COUNT(*) FROM lab_reserve" + 
                (user.getRole() != 1 ? " WHERE student_id = ?" : "");
            PreparedStatement countStmt = conn.prepareStatement(countSql);
            if (user.getRole() != 1) {
                countStmt.setInt(1, user.getStudentId());
            }
            ResultSet countRs = countStmt.executeQuery();
            int total = 0;
            if (countRs.next()) {
                total = countRs.getInt(1);
            }
            
            // 查询数据
            PreparedStatement pstmt = conn.prepareStatement(sql.toString());
            int paramIndex = 1;
            if (user.getRole() != 1) {
                pstmt.setInt(paramIndex++, user.getStudentId());
            }
            pstmt.setInt(paramIndex++, (page - 1) * pageSize);
            pstmt.setInt(paramIndex, pageSize);
            
            ResultSet rs = pstmt.executeQuery();
            List<LabReserve> reserves = new ArrayList<>();
            while (rs.next()) {
                LabReserve reserve = new LabReserve();
                reserve.setReserveId(rs.getInt("reserve_id"));
                reserve.setLabId(rs.getInt("lab_id"));
                reserve.setLabName(rs.getString("lab_name"));
                reserve.setStudentId(rs.getInt("student_id"));
                reserve.setStudentName(rs.getString("student_name"));
                reserve.setReserveNum(rs.getString("reserve_num"));
                reserve.setTel(rs.getString("tel"));
                reserve.setReserveTime(rs.getTimestamp("reserve_time"));
                reserve.setCreateTime(rs.getTimestamp("create_time"));
                reserves.add(reserve);
            }
            
            // 设置分页相关属性
            req.setAttribute("reserves", reserves);
            req.setAttribute("page", page);
            req.setAttribute("pageSize", pageSize);
            req.setAttribute("total", total);
            req.setAttribute("totalPages", (total + pageSize - 1) / pageSize);
            
            req.getRequestDispatcher("/reserveList.jsp").forward(req, resp);
        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void deleteReserve(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int reserveId = Integer.parseInt(req.getParameter("reserveId"));
        
        try (Connection conn = DbUtil.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // 获取预约信息
                String selectSql = "SELECT lab_id FROM lab_reserve WHERE reserve_id = ?";
                PreparedStatement selectStmt = conn.prepareStatement(selectSql);
                selectStmt.setInt(1, reserveId);
                ResultSet rs = selectStmt.executeQuery();
                
                if (rs.next()) {
                    int labId = rs.getInt("lab_id");
                    
                    // 删除预约记录
                    String deleteSql = "DELETE FROM lab_reserve WHERE reserve_id = ?";
                    PreparedStatement deleteStmt = conn.prepareStatement(deleteSql);
                    deleteStmt.setInt(1, reserveId);
                    
                    // 更新实验室已预约人数
                    String updateSql = "UPDATE lab SET reserved_num = reserved_num - 1 WHERE lab_id = ?";
                    PreparedStatement updateStmt = conn.prepareStatement(updateSql);
                    updateStmt.setInt(1, labId);
                    
                    deleteStmt.executeUpdate();
                    updateStmt.executeUpdate();
                    
                    conn.commit();
                }
                
                resp.sendRedirect(req.getContextPath() + "/reserve/list");
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
                resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "删除失败");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
