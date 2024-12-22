<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>出错了 - 实验室预约系统</title>
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
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            padding: 2rem;
        }

        .error-container {
            background: white;
            padding: 3rem;
            border-radius: 16px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            text-align: center;
            max-width: 600px;
            width: 100%;
        }

        .error-icon {
            font-size: 5rem;
            color: #e53e3e;
            margin-bottom: 1.5rem;
            animation: bounce 2s infinite;
        }

        @keyframes bounce {
            0%, 100% {
                transform: translateY(0);
            }
            50% {
                transform: translateY(-10px);
            }
        }

        .error-title {
            font-size: 2rem;
            color: #2d3748;
            margin-bottom: 1rem;
            font-weight: 600;
        }

        .error-message {
            color: #718096;
            margin-bottom: 2rem;
            line-height: 1.6;
        }

        .error-code {
            display: inline-block;
            background: #fed7d7;
            color: #c53030;
            padding: 0.5rem 1rem;
            border-radius: 9999px;
            font-weight: 600;
            margin-bottom: 2rem;
        }

        .button-group {
            display: flex;
            gap: 1rem;
            justify-content: center;
        }

        .btn {
            padding: 0.75rem 2rem;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .primary-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .primary-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
        }

        .secondary-btn {
            background: #e2e8f0;
            color: #4a5568;
        }

        .secondary-btn:hover {
            background: #cbd5e0;
        }

        .error-details {
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 2px solid #e2e8f0;
            text-align: left;
        }

        .error-details pre {
            background: #f7fafc;
            padding: 1rem;
            border-radius: 8px;
            overflow-x: auto;
            font-size: 0.875rem;
            color: #4a5568;
            margin-top: 1rem;
        }

        @media (max-width: 640px) {
            .error-container {
                padding: 2rem;
            }

            .button-group {
                flex-direction: column;
            }

            .btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <div class="error-container">
        <i class="fas fa-exclamation-circle error-icon"></i>
        
        <h1 class="error-title">出错了！</h1>
        
        <div class="error-code">
            错误代码: ${pageContext.errorData.statusCode}
        </div>
        
        <p class="error-message">
            抱歉，系统在处理您的请求时遇到了问题。<br>
            请稍后重试或联系系统管理员。
        </p>

        <div class="button-group">
            <a href="${pageContext.request.contextPath}/index.jsp" class="btn primary-btn">
                <i class="fas fa-home"></i> 返回首页
            </a>
            <a href="javascript:history.back()" class="btn secondary-btn">
                <i class="fas fa-arrow-left"></i> 返回上一页
            </a>
        </div>

        <c:if test="${pageContext.errorData.throwable != null}">
            <div class="error-details">
                <h3>错误详情：</h3>
                <pre>${pageContext.errorData.throwable.message}</pre>
            </div>
        </c:if>
    </div>
</body>
</html>