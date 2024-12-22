package com.lab.servlet;

import com.lab.entity.Lab;
import com.lab.utils.DbUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/lab/*")
public class LabServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("utf-8");
        resp.setContentType("text/html;charset=utf-8");
        
        String path = req.getPathInfo();
        if ("/list".equals(path)) {
            listLabs(req, resp);
        } else if ("/add".equals(path)) {
            if ("GET".equalsIgnoreCase(req.getMethod())) {
                // 显示添加页面
                req.getRequestDispatcher("/labAdd.jsp").forward(req, resp);
            } else {
                // 处理添加请求
                addLab(req, resp);
            }
        } else if ("/edit".equals(path)) {
            editLab(req, resp);
        } else if ("/delete".equals(path)) {
            deleteLab(req, resp);
        }
    }

    private void listLabs(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try (Connection conn = DbUtil.getConnection()) {
            int page = 1;
            int pageSize = 5;
            String pageStr = req.getParameter("page");
            String labName = req.getParameter("labName");
            
            if (pageStr != null && !pageStr.isEmpty()) {
                page = Integer.parseInt(pageStr);
            }
            
            // 构建SQL语句
            StringBuilder sql = new StringBuilder("SELECT * FROM lab");
            if (labName != null && !labName.isEmpty()) {
                sql.append(" WHERE lab_name LIKE ?");
            }
            sql.append(" LIMIT ?, ?");
            
            // 获取总记录数
            String countSql = "SELECT COUNT(*) FROM lab" + 
                (labName != null && !labName.isEmpty() ? " WHERE lab_name LIKE ?" : "");
            PreparedStatement countStmt = conn.prepareStatement(countSql);
            if (labName != null && !labName.isEmpty()) {
                countStmt.setString(1, "%" + labName + "%");
            }
            ResultSet countRs = countStmt.executeQuery();
            int total = 0;
            if (countRs.next()) {
                total = countRs.getInt(1);
            }
            
            // 查询数据
            PreparedStatement pstmt = conn.prepareStatement(sql.toString());
            int paramIndex = 1;
            if (labName != null && !labName.isEmpty()) {
                pstmt.setString(paramIndex++, "%" + labName + "%");
            }
            pstmt.setInt(paramIndex++, (page - 1) * pageSize);
            pstmt.setInt(paramIndex, pageSize);
            
            ResultSet rs = pstmt.executeQuery();
            List<Lab> labs = new ArrayList<>();
            while (rs.next()) {
                Lab lab = new Lab();
                lab.setLabId(rs.getInt("lab_id"));
                lab.setLabName(rs.getString("lab_name"));
                lab.setEnableReserveNum(rs.getInt("enable_reserve_num"));
                lab.setReservedNum(rs.getInt("reserved_num"));
                lab.setLabDescription(rs.getString("lab_description"));
                labs.add(lab);
            }
            
            // 设置分页相关属性
            req.setAttribute("labs", labs);
            req.setAttribute("page", page);
            req.setAttribute("pageSize", pageSize);
            req.setAttribute("total", total);
            req.setAttribute("totalPages", (total + pageSize - 1) / pageSize);
            req.setAttribute("labName", labName);
            
            req.getRequestDispatcher("/labList.jsp").forward(req, resp);
        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void addLab(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String labName = req.getParameter("labName");
            int enableReserveNum = Integer.parseInt(req.getParameter("enableReserveNum"));
            String labDescription = req.getParameter("labDescription");
            
            // 验证输入
            if (labName == null || labName.trim().isEmpty()) {
                req.setAttribute("error", "实验室名称不能为空");
                req.getRequestDispatcher("/labAdd.jsp").forward(req, resp);
                return;
            }
            
            if (enableReserveNum <= 0) {
                req.setAttribute("error", "可预约人数必须大于0");
                req.getRequestDispatcher("/labAdd.jsp").forward(req, resp);
                return;
            }
            
            try (Connection conn = DbUtil.getConnection()) {
                // 检查实验室名称是否已存在
                String checkSql = "SELECT COUNT(*) FROM lab WHERE lab_name = ?";
                PreparedStatement checkStmt = conn.prepareStatement(checkSql);
                checkStmt.setString(1, labName);
                ResultSet rs = checkStmt.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    req.setAttribute("error", "实验室名称已存在");
                    req.getRequestDispatcher("/labAdd.jsp").forward(req, resp);
                    return;
                }
                
                // 插入新实验室
                String sql = "INSERT INTO lab (lab_name, enable_reserve_num, reserved_num, lab_description) VALUES (?, ?, 0, ?)";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, labName);
                pstmt.setInt(2, enableReserveNum);
                pstmt.setString(3, labDescription);
                
                int result = pstmt.executeUpdate();
                if (result > 0) {
                    resp.sendRedirect(req.getContextPath() + "/lab/list");
                } else {
                    req.setAttribute("error", "添加失败");
                    req.getRequestDispatcher("/labAdd.jsp").forward(req, resp);
                }
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "请输入有效的数字");
            req.getRequestDispatcher("/labAdd.jsp").forward(req, resp);
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "数据库操作失败");
            req.getRequestDispatcher("/labAdd.jsp").forward(req, resp);
        }
    }

    private void editLab(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if ("GET".equalsIgnoreCase(req.getMethod())) {
            // 获取实验室信息
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
                    lab.setLabDescription(rs.getString("lab_description"));
                    
                    req.setAttribute("lab", lab);
                    req.getRequestDispatcher("/labEdit.jsp").forward(req, resp);
                }
            } catch (SQLException e) {
                e.printStackTrace();
                resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        } else {
            // 更新实验室信息
            int labId = Integer.parseInt(req.getParameter("labId"));
            String labName = req.getParameter("labName");
            int enableReserveNum = Integer.parseInt(req.getParameter("enableReserveNum"));
            String labDescription = req.getParameter("labDescription");
            
            try (Connection conn = DbUtil.getConnection()) {
                String sql = "UPDATE lab SET lab_name=?, enable_reserve_num=?, lab_description=? WHERE lab_id=?";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, labName);
                pstmt.setInt(2, enableReserveNum);
                pstmt.setString(3, labDescription);
                pstmt.setInt(4, labId);
                
                int result = pstmt.executeUpdate();
                if (result > 0) {
                    resp.sendRedirect(req.getContextPath() + "/lab/list");
                } else {
                    req.setAttribute("error", "修改失败");
                    req.getRequestDispatcher("/labEdit.jsp").forward(req, resp);
                }
            } catch (SQLException e) {
                e.printStackTrace();
                resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        }
    }

    private void deleteLab(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int labId = Integer.parseInt(req.getParameter("labId"));
        
        try (Connection conn = DbUtil.getConnection()) {
            String sql = "DELETE FROM lab WHERE lab_id = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, labId);
            
            int result = pstmt.executeUpdate();
            if (result > 0) {
                resp.sendRedirect(req.getContextPath() + "/lab/list");
            } else {
                resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "删除失败");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }
}