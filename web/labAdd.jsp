<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>实验室预约系统 - 添加实验室</title>
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

        /* 表单样式 */
        .form-container {
            background: white;
            padding: 2rem;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            max-width: 800px;
            margin: 0 auto;
        }

        .form-title {
            font-size: 1.5rem;
            color: #2d3748;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid #e2e8f0;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            display: block;
            color: #4a5568;
            margin-bottom: 0.5rem;
            font-weight: 500;
        }

        .form-input {
            width: 100%;
            padding: 0.75rem;
            border: 2px solid #e2e8f0;
            border-radius: 6px;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .form-input:focus {
            border-color: #4299e1;
            box-shadow: 0 0 0 3px rgba(66, 153, 225, 0.1);
            outline: none;
        }

        .form-textarea {
            min-height: 120px;
            resize: vertical;
        }

        .button-group {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
        }

        .submit-btn {
            padding: 0.75rem 2rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 1rem;
            cursor: pointer;
            transition: opacity 0.2s ease;
        }

        .submit-btn:hover {
            opacity: 0.9;
        }

        .cancel-btn {
            padding: 0.75rem 2rem;
            background: #e2e8f0;
            color: #4a5568;
            border: none;
            border-radius: 6px;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .cancel-btn:hover {
            background: #cbd5e0;
        }

        .error-message {
            background: #fed7d7;
            color: #c53030;
            padding: 1rem;
            border-radius: 6px;
            margin-bottom: 1rem;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
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
            <a href="${pageContext.request.contextPath}/lab/manage" class="menu-item active">
                <i class="fas fa-cog"></i>
                <span>实验室管理</span>
            </a>
        </c:if>
    </div>

    <!-- 主要内容区域 -->
    <main class="main-content">
        <div class="form-container">
            <h2 class="form-title">
                <i class="fas fa-plus-circle"></i> 添加新实验室
            </h2>

            <c:if test="${not empty error}">
                <div class="error-message">
                    <i class="fas fa-exclamation-circle"></i>
                    ${error}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/lab/add" method="post" onsubmit="return validateForm()">
                <div class="form-group">
                    <label class="form-label" for="labName">实验室名称</label>
                    <input type="text" 
                           id="labName" 
                           name="labName" 
                           class="form-input" 
                           required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="enableReserveNum">可预约人数</label>
                    <input type="number" 
                           id="enableReserveNum" 
                           name="enableReserveNum" 
                           class="form-input" 
                           min="1" 
                           required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="labDescription">实验室描述</label>
                    <textarea id="labDescription" 
                              name="labDescription" 
                              class="form-input form-textarea" 
                              required></textarea>
                </div>

                <div class="button-group">
                    <button type="submit" class="submit-btn">
                        <i class="fas fa-save"></i> 保存
                    </button>
                    <a href="${pageContext.request.contextPath}/lab/manage" 
                       class="cancel-btn">
                        <i class="fas fa-times"></i> 取消
                    </a>
                </div>
            </form>
        </div>
    </main>

    <script>
        function validateForm() {
            const labName = document.getElementById('labName').value;
            const enableReserveNum = document.getElementById('enableReserveNum').value;
            const labDescription = document.getElementById('labDescription').value;

            if (!labName.trim()) {
                alert('请输入实验室名称');
                return false;
            }

            if (enableReserveNum < 1) {
                alert('可预约人数必须大于0');
                return false;
            }

            if (!labDescription.trim()) {
                alert('请输入实验室描述');
                return false;
            }

            return true;
        }
    </script>
</body>
</html>