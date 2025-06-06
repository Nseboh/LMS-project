<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Takoradi Library - Admin Login</title>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/adminlogin.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    </head>
    <body>
        <div class="container">
            <nav class="sidebar" style="background-color: #070D59;">
                <div class="logo-section">
                    <div class="logo-img">
                        <img src="<%= request.getContextPath() %>/images/TakoradiLibrary.jpeg" alt="Logo" style="border-radius: 50%; width: 40px; height: 40px;">
                    </div>
                    <h1 class="logo-text" style="color:white;">Takoardi Library</h1>
                </div>
                
            </nav>

            <main class="main-section">
                <header class="header" style="background-color:rgb(10, 18, 121);">
                    <h1>Admins Login</h1>
                </header>
                
                <div class="content-wrapper" style="background-image: url('<%= request.getContextPath() %>/images/img%201.jpeg');">
                    <div class="login-card">
                        <h3>Sign in</h3>
                        <h2 class="subtitle" style= "color: #070D59;">Welcome To Takoradi Library!!</h2>
                        <p>Your Satisfaction Is Our Priority</p>
                        
                        <%-- Display error message if any --%>
                        <% if (request.getParameter("error") != null) { %>
                            <div class="error-message">
                                <%= request.getParameter("error") %>
                            </div>
                        <% } %>
                        
                        <form class="login-form" action="process_login.jsp" method="post">
                            <div class="input-group">
                                <span class="material-icons input-icon">mail</span>
                                <input type="email" name="email" placeholder="Username/Email" required>
                            </div>
                            
                            <div class="input-group">
                                <span class="material-icons input-icon">lock</span>
                                <input type="password" name="password" placeholder="Password" required>
                                <span class="material-icons show-password">visibility</span>
                            </div>
                            
                            <div class="forgot-password">
                                <a href="#">Forgot Password?</a>
                            </div>
                            
                            <button type="submit" class="login-button"  style="background-color:rgb(10, 18, 121);">Login</button>
                        </form>
                    </div>
                </div>
            </main>
        </div>
        
        <script>
            // Show/Hide Password functionality
            document.querySelector('.show-password').addEventListener('click', function() {
                const passwordInput = document.querySelector('input[type="password"]');
                const icon = this;
                
                if (passwordInput.type === 'password') {
                    passwordInput.type = 'text';
                    icon.textContent = 'visibility_off';
                } else {
                    passwordInput.type = 'password';
                    icon.textContent = 'visibility';
                }
            });
        </script>
        
        
    </body>
</html>