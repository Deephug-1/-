下·<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2024/12/10
  Time: 14:11
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>实验室预约系统 - 实验室管理</title>
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

        /* 页面标题 */
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid #e2e8f0;
        }

        .page-title {
            font-size: 1.8rem;
            color: #2d3748;
            font-weight: 600;
        }

        /* 添加按钮样式 */
        .add-btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1.5rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.3s ease;
            box-shadow: 0 4px 6px rgba(102, 126, 234, 0.2);
        }

        .add-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 8px rgba(102, 126, 234, 0.3);
        }

        /* 表格样式 */
        .lab-table-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            overflow: hidden;
        }

        .lab-table {
            width: 100%;
            border-collapse: collapse;
        }

        .lab-table th {
            background: #f8fafc;
            padding: 1.2rem 1.5rem;
            text-align: left;
            color: #4a5568;
            font-weight: 600;
            font-size: 0.95rem;
            border-bottom: 2px solid #e2e8f0;
        }

        .lab-table td {
            padding: 1.2rem 1.5rem;
            color: #2d3748;
            border-bottom: 1px solid #e2e8f0;
        }

        .lab-table tr:hover {
            background: #f7fafc;
        }

        .lab-table tr:last-child td {
            border-bottom: none;
        }

        /* 操作按钮样式 */
        .action-buttons {
            display: flex;
            gap: 0.5rem;
        }

        .action-btn {
            display: inline-flex;
            align-items: center;
            gap: 0.3rem;
            padding: 0.5rem 1rem;
            border-radius: 6px;
            font-size: 0.875rem;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.2s ease;
        }

        .edit-btn {
            background: #4299e1;
            color: white;
        }

        .edit-btn:hover {
            background: #3182ce;
        }

        .delete-btn {
            background: #e53e3e;
            color: white;
        }

        .delete-btn:hover {
            background: #c53030;
        }

        /* 状态标签 */
        .status-badge {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.875rem;
            font-weight: 500;
        }

        .status-available {
            background: #c6f6d5;
            color: #2f855a;
        }

        .status-full {
            background: #fed7d7;
            color: #c53030;
        }

        /* 响应式设计 */
        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
            }

            .main-content {
                margin-left: 0;
            }

            .lab-table-container {
                overflow-x: auto;
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
        <a href="${pageContext.request.contextPath}/index.jsp" class="menu-item">
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
        <c:if test="${sessionScope.user.role == 1}">
            <a href="${pageContext.request.contextPath}/lab/edit" class="menu-item active">
                <i class="fas fa-cog"></i>
                <span>实验室管理</span>
            </a>
        </c:if>
    </div>

    <!-- 主要内容区域 -->
    <main class="main-content">
        <div class="page-header">
            <h1 class="page-title">实验室管理</h1>
            <a href="${pageContext.request.contextPath}/lab/add" class="add-btn">
                <i class="fas fa-plus"></i>
                添加实验室
            </a>
        </div>

        <div class="lab-table-container">
            <table class="lab-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>实验室名称</th>
                        <th>可预约人数</th>
                        <th>已预约人数</th>
                        <th>状态</th>
                        <th>描述</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="lab" items="${labs}">
                        <tr>
                            <td>${lab.labId}</td>
                            <td>${lab.labName}</td>
                            <td>${lab.enableReserveNum}</td>
                            <td>${lab.reservedNum}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${lab.enableReserveNum > lab.reservedNum}">
                                        <span class="status-badge status-available">可预约</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge status-full">已满</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${lab.labDescription}</td>
                            <td>
                                <div class="action-buttons">
                                    <a href="${pageContext.request.contextPath}/lab/edit?id=${lab.labId}" 
                                       class="action-btn edit-btn">
                                        <i class="fas fa-edit"></i>
                                        编辑
                                    </a>
                                    <a href="javascript:void(0)" 
                                       onclick="deleteLab(${lab.labId}, '${lab.labName}')"
                                       class="action-btn delete-btn">
                                        <i class="fas fa-trash"></i>
                                        删除
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </main>

    <script>
        function deleteLab(labId, labName) {
            if (confirm('确定要删除实验室 "' + labName + '" 吗？此操作不可恢复。')) {
                // 发送删除请求
                fetch('${pageContext.request.contextPath}/lab/delete?id=' + labId, {
                    method: 'GET',
                    credentials: 'same-origin'
                })
                .then(response => {
                    if (response.ok) {
                        // 删除成功，刷新页面
                        window.location.reload();
                    } else {
                        // 删除失败
                        alert('删除失败，请稍后重试');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('删除失败，请稍后重试');
                });
            }
        }
    </script>
</body>
</html>