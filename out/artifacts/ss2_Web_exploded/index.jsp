<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2024/12/9
  Time: 17:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>实验室预约系统 - 主页</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.bootcdn.net/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f7fafc;
            min-height: 100vh;
        }

        /* 导航栏样式 */
        .navbar {
            background: #2d3748;
            color: white;
            padding: 1rem 2rem;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 100;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .navbar-brand {
            font-size: 1.5rem;
            font-weight: bold;
            color: white;
            text-decoration: none;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .logout-btn {
            padding: 0.5rem 1rem;
            background: #e53e3e;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            font-size: 0.9rem;
        }

        /* 侧边栏样式 */
        .sidebar {
            position: fixed;
            left: 0;
            top: 60px;
            bottom: 0;
            width: 250px;
            background: white;
            box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
            padding: 2rem 0;
        }

        .menu-item {
            padding: 1rem 2rem;
            display: flex;
            align-items: center;
            gap: 1rem;
            color: #4a5568;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .menu-item:hover {
            background: #edf2f7;
            color: #2b6cb0;
        }

        .menu-item.active {
            background: #ebf8ff;
            color: #2b6cb0;
            border-right: 3px solid #2b6cb0;
        }

        /* 主要内容区域 */
        .main-content {
            margin-left: 250px;
            margin-top: 60px;
            padding: 2rem;
        }

        .dashboard-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .card {
            background: white;
            padding: 1.5rem;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .card-header {
            font-size: 1.1rem;
            color: #2d3748;
            margin-bottom: 1rem;
            font-weight: 600;
        }

        .card-value {
            font-size: 2rem;
            color: #2b6cb0;
            font-weight: bold;
        }

        .welcome-message {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem;
            border-radius: 8px;
            margin-bottom: 2rem;
        }

        .welcome-message h1 {
            font-size: 1.8rem;
            margin-bottom: 0.5rem;
        }

        .welcome-message p {
            opacity: 0.9;
        }

        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
            }

            .main-content {
                margin-left: 0;
            }
        }
    </style>
</head>
<body>
    <!-- 导航栏 -->
    <nav class="navbar">
        <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-brand">
            实验室预约系统
        </a>
        <div class="user-info">
            <span>欢迎，${sessionScope.user.studentName}</span>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">
                <i class="fas fa-sign-out-alt"></i> 退出
            </a>
        </div>
    </nav>

    <!-- 侧边栏 -->
    <div class="sidebar">
        <a href="${pageContext.request.contextPath}/index.jsp" class="menu-item active">
            <i class="fas fa-home"></i>
            <span>主页</span>
        </a>
        <a href="${pageContext.request.contextPath}/lab/list" class="menu-item">
            <i class="fas fa-flask"></i>
            <span>实验室列表</span>
        </a>
        <a href="${pageContext.request.contextPath}/reserveList.jsp" class="menu-item">
            <i class="fas fa-calendar-alt"></i>
            <span>我的预约</span>
        </a>
        <a href="${pageContext.request.contextPath}/regist.jsp" class="menu-item">
            <i class="fas fa-user-plus"></i>
            <span>用户注册</span>
        </a>
        <c:if test="${sessionScope.user.role == 1}">
            <a href="${pageContext.request.contextPath}/lab/edit" class="menu-item">
                <i class="fas fa-cog"></i>
                <span>实验室管理</span>
            </a>
        </c:if>
    </div>

    <!-- 主要内容区域 -->
    <main class="main-content">
        <div class="welcome-message">
            <h1>欢迎回来，${sessionScope.user.studentName}</h1>
            <p>今天是 <%= new java.text.SimpleDateFormat("yyyy年MM月dd日").format(new java.util.Date()) %></p>
        </div>

        <div class="dashboard-cards">
            <div class="card">
                <div class="card-header">
                    <i class="fas fa-users"></i> 当前在线人数
                </div>
                <div class="card-value">${applicationScope.onlineCount}</div>
            </div>
            <div class="card">
                <div class="card-header">
                    <i class="fas fa-calendar-check"></i> 我的预约数
                </div>
                <div class="card-value">0</div>
            </div>
            <div class="card">
                <div class="card-header">
                    <i class="fas fa-flask"></i> 可用实验室
                </div>
                <div class="card-value">0</div>
            </div>
        </div>
    </main>
</body>
</html>