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
import java.sql.SQLException;

@WebServlet("/lab/delete")
public class LabDeleteServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String labId = request.getParameter("id");
        
        try (Connection conn = DbUtil.getConnection()) {
            String sql = "DELETE FROM lab WHERE lab_id = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(labId));
            
            int result = pstmt.executeUpdate();
            if (result > 0) {
                // 删除成功
                response.sendRedirect(request.getContextPath() + "/lab/edit");
            } else {
                // 删除失败
                request.setAttribute("error", "删除失败，实验室不存在");
                request.getRequestDispatcher("/lab/edit").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "删除失败，该实验室可能有关联的预约记录");
            request.getRequestDispatcher("/lab/edit").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
} 