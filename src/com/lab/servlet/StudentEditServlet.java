package com.lab.servlet;

import com.lab.entity.Student;
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

@WebServlet("/student/*")
public class StudentEditServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if ("/info".equals(path)) {
            // 获取学生信息
            Student user = (Student) req.getSession().getAttribute("user");
            try (Connection conn = DbUtil.getConnection()) {
                String sql = "SELECT * FROM student WHERE student_id = ?";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, user.getStudentId());
                ResultSet rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    Student student = new Student();
                    student.setStudentId(rs.getInt("student_id"));
                    student.setStudentName(rs.getString("student_name"));
                    student.setUsername(rs.getString("username"));
                    student.setPassword(rs.getString("password"));
                    student.setAge(rs.getInt("age"));
                    student.setSex(rs.getInt("sex"));
                    student.setTel(rs.getString("tel"));
                    student.setRole(rs.getInt("role"));
                    
                    req.setAttribute("student", student);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            req.getRequestDispatcher("/studentEdit.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        
        String studentId = req.getParameter("studentId");
        String password = req.getParameter("password");
        String age = req.getParameter("age");
        String sex = req.getParameter("sex");
        String tel = req.getParameter("tel");
        
        try (Connection conn = DbUtil.getConnection()) {
            String sql = "UPDATE student SET password=?, age=?, sex=?, tel=? WHERE student_id=?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, password);
            pstmt.setInt(2, Integer.parseInt(age));
            pstmt.setInt(3, Integer.parseInt(sex));
            pstmt.setString(4, tel);
            pstmt.setInt(5, Integer.parseInt(studentId));
            
            int result = pstmt.executeUpdate();
            if (result > 0) {
                resp.sendRedirect(req.getContextPath() + "/index.jsp");
            } else {
                req.setAttribute("error", "修改失败");
                req.getRequestDispatcher("/studentEdit.jsp").forward(req, resp);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
} 