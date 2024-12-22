<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2024/12/11
  Time: 22:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>个人信息 - 实验室预约系统</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <style>
        body {
            margin: 0;
            min-height: 100vh;
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .container {
            background: rgba(255, 255, 255, 0.95);
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 500px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .header {
            text-align: center;
            margin-bottom: 30px;
        }

        .page-title {
            font-size: 24px;
            color: #333;
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .form-group {
            margin-bottom: 25px;
            position: relative;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .form-group input {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 10px;
            font-size: 15px;
            transition: all 0.3s ease;
            box-sizing: border-box;
            background: rgba(255, 255, 255, 0.9);
        }

        .form-group input:focus {
            outline: none;
            border-color: #4CAF50;
            box-shadow: 0 0 0 2px rgba(76, 175, 80, 0.2);
        }

        .form-group i {
            color: #4CAF50;
        }

        .form-group.readonly input {
            background-color: #f5f5f5;
            cursor: not-allowed;
        }

        .radio-group {
            display: flex;
            gap: 20px;
            padding: 10px 0;
        }

        .radio-option {
            display: flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
        }

        .radio-option input[type="radio"] {
            width: 20px;
            height: 20px;
            margin: 0;
            position: relative;
            cursor: pointer;
        }

        .radio-option input[type="radio"]::before {
            content: '';
            position: absolute;
            width: 20px;
            height: 20px;
            border: 2px solid #4CAF50;
            border-radius: 50%;
            background: white;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            transition: all 0.3s ease;
        }

        .radio-option input[type="radio"]:checked::before {
            background: #4CAF50;
            box-shadow: inset 0 0 0 4px white;
        }

        .buttons-container {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }

        .btn {
            flex: 1;
            padding: 12px 25px;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            color: white;
        }

        .btn-primary {
            background: linear-gradient(145deg, #4CAF50, #45a049);
        }

        .btn-secondary {
            background: linear-gradient(145deg, #ff5252, #f44336);
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }

        .error-message {
            background: #ffebee;
            color: #f44336;
            padding: 10px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
        }

        @media (max-width: 500px) {
            .container {
                padding: 20px;
            }

            .buttons-container {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1 class="page-title">
            <i class="material-icons">person</i>
            个人信息
        </h1>
    </div>

    <form action="${pageContext.request.contextPath}/student/edit" method="post" onsubmit="return validateForm()">
        <input type="hidden" name="studentId" value="${student.studentId}">

        <div class="form-group readonly">
            <label>
                <i class="material-icons">badge</i>
                姓名
            </label>
            <input type="text" name="studentName" value="${student.studentName}" readonly>
        </div>

        <div class="form-group readonly">
            <label>
                <i class="material-icons">account_circle</i>
                登录账号
            </label>
            <input type="text" name="username" value="${student.username}" readonly>
        </div>

        <div class="form-group">
            <label>
                <i class="material-icons">lock</i>
                密码
            </label>
            <input type="password" name="password" required>
        </div>

        <div class="form-group">
            <label>
                <i class="material-icons">cake</i>
                年龄
            </label>
            <input type="number" name="age" value="${student.age}" required min="1" max="120">
        </div>

        <div class="form-group">
            <label>
                <i class="material-icons">wc</i>
                性别
            </label>
            <div class="radio-group">
                <label class="radio-option">
                    <input type="radio" name="sex" value="1" ${student.sex == 1 ? 'checked' : ''}>
                    <span>男</span>
                </label>
                <label class="radio-option">
                    <input type="radio" name="sex" value="2" ${student.sex == 2 ? 'checked' : ''}>
                    <span>女</span>
                </label>
            </div>
        </div>

        <div class="form-group">
            <label>
                <i class="material-icons">phone</i>
                联系电话
            </label>
            <input type="tel" name="tel" value="${student.tel}" required>
        </div>

        <c:if test="${not empty error}">
            <div class="error-message">
                <i class="material-icons">error</i>
                ${error}
            </div>
        </c:if>

        <div class="buttons-container">
            <button type="button" class="btn btn-secondary"
                    onclick="window.location.href='${pageContext.request.contextPath}/index.jsp'">
                <i class="material-icons">arrow_back</i>
                返回
            </button>
            <button type="submit" class="btn btn-primary">
                <i class="material-icons">save</i>
                保存
            </button>
        </div>
    </form>
</div>

<script>
    function validateForm() {
        const password = document.querySelector('input[name="password"]').value;
        const age = document.querySelector('input[name="age"]').value;
        const tel = document.querySelector('input[name="tel"]').value;

        if (!password) {
            showError('请输入密码');
            return false;
        }

        if (age < 1 || age > 120) {
            showError('年龄必须在1-120岁之间');
            return false;
        }

        if (!/^1[3-9]\d{9}$/.test(tel)) {
            showError('请输入正确的手机号码');
            return false;
        }

        return true;
    }

    function showError(message) {
        let errorDiv = document.querySelector('.error-message');
        if (!errorDiv) {
            errorDiv = document.createElement('div');
            errorDiv.className = 'error-message';
            const form = document.querySelector('form');
            form.insertBefore(errorDiv, document.querySelector('.buttons-container'));
        }
        errorDiv.innerHTML = '<i class="material-icons">error</i>' + message;
    }
</script>
</body>
</html>