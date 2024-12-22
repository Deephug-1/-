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

@WebServlet("/lab/list")
public class LabListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try (Connection conn = DbUtil.getConnection()) {
            String sql = "SELECT * FROM lab";
            PreparedStatement pstmt = conn.prepareStatement(sql);
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

            request.setAttribute("labs", labs);
            request.getRequestDispatcher("/labList.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
} 