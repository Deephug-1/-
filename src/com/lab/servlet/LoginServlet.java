package com.lab.servlet;

import com.lab.entity.Student;
import com.lab.utils.DbUtil;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.concurrent.ConcurrentHashMap;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        try (Connection conn = DbUtil.getConnection()) {
            String sql = "SELECT * FROM student WHERE username = ? AND password = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                Student student = new Student();
                student.setStudentId(rs.getInt("student_id"));
                student.setUsername(rs.getString("username"));
                student.setStudentName(rs.getString("student_name"));
                student.setRole(rs.getInt("role"));

                HttpSession session = request.getSession();
                session.setAttribute("user", student);

                ServletContext context = session.getServletContext();
                @SuppressWarnings("unchecked")
                ConcurrentHashMap<String, Long> onlineUsers =
                    (ConcurrentHashMap<String, Long>) context.getAttribute("onlineUsers");
                if (onlineUsers != null) {
                    onlineUsers.put(session.getId(), System.currentTimeMillis());
                    context.setAttribute("onlineCount", onlineUsers.size());
                }

                response.sendRedirect(request.getContextPath() + "/index.jsp");
            } else {
                request.setAttribute("error", "用户名或密码错误");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "系统错误，请稍后重试");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}