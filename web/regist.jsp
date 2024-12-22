<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>实验室预约系统 - 用户注册</title>
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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 2rem;
        }

        .register-container {
            width: 100%;
            max-width: 800px;
            margin: auto;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 16px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
            backdrop-filter: blur(10px);
            overflow: hidden;
        }

        .register-header {
            background: #2d3748;
            color: white;
            padding: 2rem;
            text-align: center;
        }

        .register-header h1 {
            font-size: 2rem;
            margin-bottom: 0.5rem;
        }

        .register-header p {
            color: #cbd5e0;
            font-size: 0.95rem;
        }

        .register-form {
            padding: 2rem;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1.5rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
            position: relative;
        }

        .form-group.full-width {
            grid-column: span 2;
        }

        .form-label {
            display: block;
            color: #4a5568;
            margin-bottom: 0.5rem;
            font-weight: 500;
        }

        .form-input {
            width: 100%;
            padding: 0.75rem 1rem 0.75rem 2.5rem;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: white;
        }

        .form-input:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            outline: none;
        }

        .form-group i {
            position: absolute;
            left: 1rem;
            top: 2.3rem;
            color: #a0aec0;
        }

        .gender-options {
            display: flex;
            gap: 1rem;
            margin-top: 0.5rem;
        }

        .gender-option {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            cursor: pointer;
        }

        .gender-option input[type="radio"] {
            width: 1.2rem;
            height: 1.2rem;
            cursor: pointer;
        }

        .button-group {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
        }

        .submit-btn {
            flex: 1;
            padding: 1rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .submit-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
        }

        .cancel-btn {
            flex: 1;
            padding: 1rem;
            background: #e2e8f0;
            color: #4a5568;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            text-align: center;
        }

        .cancel-btn:hover {
            background: #cbd5e0;
        }

        .error-message {
            background: #fed7d7;
            color: #c53030;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }

            .form-group.full-width {
                grid-column: auto;
            }

            body {
                padding: 1rem;
            }
        }

        /* 密码强度指示器样式 */
        .password-strength {
            margin-top: 0.5rem;
            height: 4px;
            border-radius: 2px;
            background: #e2e8f0;
            overflow: hidden;
        }

        .strength-bar {
            height: 100%;
            width: 0;
            transition: all 0.3s ease;
        }

        .strength-weak {
            background: #f56565;
            width: 33.33%;
        }

        .strength-medium {
            background: #ecc94b;
            width: 66.66%;
        }

        .strength-strong {
            background: #48bb78;
            width: 100%;
        }

        .strength-text {
            font-size: 0.8rem;
            margin-top: 0.25rem;
            color: #718096;
        }

        /* 验证提示样式 */
        .validation-message {
            position: absolute;
            right: 0;
            top: 0;
            font-size: 0.8rem;
            color: #718096;
        }

        .validation-message.valid {
            color: #48bb78;
        }

        .validation-message.invalid {
            color: #f56565;
        }

        /* 输入框验证状态样式 */
        .form-input.valid {
            border-color: #48bb78;
        }

        .form-input.invalid {
            border-color: #f56565;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="register-header">
            <h1>用户注册</h1>
            <p>欢迎加入实验室预约系统</p>
        </div>

        <form class="register-form" action="${pageContext.request.contextPath}/regist" method="post" onsubmit="return validateForm()">
            <c:if test="${not empty error}">
                <div class="error-message">
                    <i class="fas fa-exclamation-circle"></i>
                    ${error}
                </div>
            </c:if>

            <div class="form-grid">
                <div class="form-group">
                    <label class="form-label" for="username">用户名</label>
                    <i class="fas fa-user"></i>
                    <input type="text" 
                           id="username" 
                           name="username" 
                           class="form-input" 
                           required>
                    <div class="validation-message"></div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="studentName">姓名</label>
                    <i class="fas fa-id-card"></i>
                    <input type="text" 
                           id="studentName" 
                           name="studentName" 
                           class="form-input" 
                           required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="password">密码</label>
                    <i class="fas fa-lock"></i>
                    <input type="password" 
                           id="password" 
                           name="password" 
                           class="form-input" 
                           required>
                    <div class="password-strength">
                        <div class="strength-bar"></div>
                    </div>
                    <div class="strength-text"></div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="confirmPassword">确认密码</label>
                    <i class="fas fa-lock"></i>
                    <input type="password" 
                           id="confirmPassword" 
                           name="confirmPassword" 
                           class="form-input" 
                           required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="age">年龄</label>
                    <i class="fas fa-birthday-cake"></i>
                    <input type="number" 
                           id="age" 
                           name="age" 
                           class="form-input" 
                           min="1" 
                           max="150" 
                           required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="tel">联系电话</label>
                    <i class="fas fa-phone"></i>
                    <input type="tel" 
                           id="tel" 
                           name="tel" 
                           class="form-input" 
                           pattern="[0-9]{11}" 
                           required>
                </div>

                <div class="form-group full-width">
                    <label class="form-label">性别</label>
                    <div class="gender-options">
                        <label class="gender-option">
                            <input type="radio" name="sex" value="1" checked>
                            <span>男</span>
                        </label>
                        <label class="gender-option">
                            <input type="radio" name="sex" value="2">
                            <span>女</span>
                        </label>
                    </div>
                </div>
            </div>

            <div class="button-group">
                <button type="submit" class="submit-btn">
                    <i class="fas fa-user-plus"></i> 注册
                </button>
                <a href="${pageContext.request.contextPath}/login.jsp" class="cancel-btn">
                    <i class="fas fa-arrow-left"></i> 返回登录
                </a>
            </div>
        </form>
    </div>

    <script>
        // 密码强度检查
        function checkPasswordStrength(password) {
            let strength = 0;
            if (password.length >= 8) strength++;
            if (/[A-Z]/.test(password)) strength++;
            if (/[0-9]/.test(password)) strength++;
            if (/[^A-Za-z0-9]/.test(password)) strength++;
            return strength;
        }

        // 更新密码强度指示器
        function updatePasswordStrength(password) {
            const strengthBar = document.querySelector('.strength-bar');
            const strengthText = document.querySelector('.strength-text');
            const strength = checkPasswordStrength(password);

            strengthBar.className = 'strength-bar';
            if (password.length === 0) {
                strengthBar.style.width = '0';
                strengthText.textContent = '';
            } else if (strength <= 1) {
                strengthBar.classList.add('strength-weak');
                strengthText.textContent = '弱';
                strengthText.style.color = '#f56565';
            } else if (strength <= 2) {
                strengthBar.classList.add('strength-medium');
                strengthText.textContent = '中';
                strengthText.style.color = '#ecc94b';
            } else {
                strengthBar.classList.add('strength-strong');
                strengthText.textContent = '强';
                strengthText.style.color = '#48bb78';
            }
        }

        // 实时验证用户名
        document.getElementById('username').addEventListener('input', function(e) {
            const username = e.target.value;
            if (username.length >= 3) {
                // 这里可以添加 AJAX 检查用户名是否已存在
                e.target.classList.add('valid');
                e.target.classList.remove('invalid');
            } else {
                e.target.classList.add('invalid');
                e.target.classList.remove('valid');
            }
        });

        // 实时验证密码
        document.getElementById('password').addEventListener('input', function(e) {
            updatePasswordStrength(e.target.value);
        });

        // 实时验证确认密码
        document.getElementById('confirmPassword').addEventListener('input', function(e) {
            const password = document.getElementById('password').value;
            if (e.target.value === password) {
                e.target.classList.add('valid');
                e.target.classList.remove('invalid');
            } else {
                e.target.classList.add('invalid');
                e.target.classList.remove('valid');
            }
        });

        // 实时验证手机号
        document.getElementById('tel').addEventListener('input', function(e) {
            const tel = e.target.value;
            if (/^1[3-9]\d{9}$/.test(tel)) {
                e.target.classList.add('valid');
                e.target.classList.remove('invalid');
            } else {
                e.target.classList.add('invalid');
                e.target.classList.remove('valid');
            }
        });

        // 表单验证
        function validateForm() {
            const username = document.getElementById('username').value;
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const age = document.getElementById('age').value;
            const tel = document.getElementById('tel').value;

            if (username.length < 3) {
                alert('用户名长度不能少于3位');
                return false;
            }

            if (checkPasswordStrength(password) <= 1) {
                alert('密码强度太弱，请包含大写字母、数字和特殊字符');
                return false;
            }

            if (password !== confirmPassword) {
                alert('两次输入的密码不一致');
                return false;
            }

            if (age < 1 || age > 150) {
                alert('请输入有效的年龄');
                return false;
            }

            if (!/^1[3-9]\d{9}$/.test(tel)) {
                alert('请输入有效的手机号码');
                return false;
            }

            return true;
        }
    </script>
</body>
</html> 