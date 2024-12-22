package com.lab.servlet;

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

@WebServlet("/regist")
public class RegistServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 获取表单数据
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String studentName = request.getParameter("studentName");
        int age = Integer.parseInt(request.getParameter("age"));
        int sex = Integer.parseInt(request.getParameter("sex"));
        String tel = request.getParameter("tel");
        
        try (Connection conn = DbUtil.getConnection()) {
            // 检查用户名是否已存在
            String checkSql = "SELECT COUNT(*) FROM student WHERE username = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setString(1, username);
            ResultSet rs = checkStmt.executeQuery();
            
            if (rs.next() && rs.getInt(1) > 0) {
                request.setAttribute("error", "用户名已存在");
                request.getRequestDispatcher("/regist.jsp").forward(request, response);
                return;
            }
            
            // 插入新用户
            String sql = "INSERT INTO student (student_name, username, password, age, sex, tel, role) " +
                        "VALUES (?, ?, ?, ?, ?, ?, 2)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, studentName);
            pstmt.setString(2, username);
            pstmt.setString(3, password);
            pstmt.setInt(4, age);
            pstmt.setInt(5, sex);
            pstmt.setString(6, tel);
            
            int result = pstmt.executeUpdate();
            if (result > 0) {
                // 注册成功，重定向到登录页面
                response.sendRedirect(request.getContextPath() + "/login.jsp");
            } else {
                // 注册失败
                request.setAttribute("error", "注册失败，请稍后重试");
                request.getRequestDispatcher("/regist.jsp").forward(request, response);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "注册失败，数据库错误");
            request.getRequestDispatcher("/regist.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "输入数据格式错误");
            request.getRequestDispatcher("/regist.jsp").forward(request, response);
        }
    }
} 