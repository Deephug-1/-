<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2024/12/10
  Time: 14:58
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>预约实验室 - 实验室预约系统</title>
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

        .info-card {
            background: #e8f5e9;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 25px;
        }

        .info-item {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 10px;
            color: #2e7d32;
        }

        .info-item:last-child {
            margin-bottom: 0;
        }

        .info-item i {
            color: #4CAF50;
        }

        .datetime-picker {
            position: relative;
        }

        .datetime-picker i {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #666;
            pointer-events: none;
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
            <i class="material-icons">event_available</i>
            预约实验室
        </h1>
    </div>

    <form action="${pageContext.request.contextPath}/reserve/add" method="post" onsubmit="return validateForm()">
        <input type="hidden" name="labId" value="${lab.labId}">

        <div class="info-card">
            <div class="info-item">
                <i class="material-icons">science</i>
                <span>实验室：${lab.labName}</span>
            </div>
            <div class="info-item">
                <i class="material-icons">group</i>
                <span>可预约人数：${lab.enableReserveNum}</span>
            </div>
            <div class="info-item">
                <i class="material-icons">how_to_reg</i>
                <span>已预约人数：${lab.reservedNum}</span>
            </div>
            <div class="info-item">
                <i class="material-icons">info</i>
                <span>剩余名额：${lab.enableReserveNum - lab.reservedNum}</span>
            </div>
        </div>

        <div class="form-group">
            <label>
                <i class="material-icons">event</i>
                预约时间
            </label>
            <div class="datetime-picker">
                <input type="datetime-local" id="reserveTime" name="reserveTime" required>
                <i class="material-icons">schedule</i>
            </div>
        </div>

        <c:if test="${not empty error}">
            <div class="error-message">
                <i class="material-icons">error</i>
                ${error}
            </div>
        </c:if>

        <div class="buttons-container">
            <button type="button" class="btn btn-secondary"
                    onclick="window.location.href='${pageContext.request.contextPath}/lab/list'">
                <i class="material-icons">arrow_back</i>
                返回
            </button>
            <button type="submit" class="btn btn-primary">
                <i class="material-icons">check_circle</i>
                确认预约
            </button>
        </div>
    </form>
</div>

<script>
    function validateForm() {
        const reserveTime = document.getElementById('reserveTime').value;
        const now = new Date();
        const selectedTime = new Date(reserveTime);

        if (!reserveTime) {
            showError('请选择预约时间');
            return false;
        }

        if (selectedTime < now) {
            showError('预约时间不能早于当前时间');
            return false;
        }

        // 设置最大预约时间为30天后
        const maxDate = new Date();
        maxDate.setDate(maxDate.getDate() + 30);
        if (selectedTime > maxDate) {
            showError('预约时间不能超过30天');
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

    // 设置日期时间选择器的最小值为当前时间
    const now = new Date();
    now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
    document.getElementById('reserveTime').min = now.toISOString().slice(0, 16);

    // 设置最大值为30天后
    const maxDate = new Date();
    maxDate.setDate(maxDate.getDate() + 30);
    maxDate.setMinutes(maxDate.getMinutes() - maxDate.getTimezoneOffset());
    document.getElementById('reserveTime').max = maxDate.toISOString().slice(0, 16);
</script>
</body>
</html>