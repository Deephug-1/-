package com.lab.listener;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;
import java.util.concurrent.ConcurrentHashMap;

@WebListener
public class OnlineCountListener implements HttpSessionListener, ServletContextListener {
    private static final String ONLINE_USERS = "onlineUsers";
    private static final String ONLINE_COUNT = "onlineCount";
    
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // 在应用启动时初始化
        ServletContext context = sce.getServletContext();
        ConcurrentHashMap<String, Long> onlineUsers = new ConcurrentHashMap<>();
        context.setAttribute(ONLINE_USERS, onlineUsers);
        context.setAttribute(ONLINE_COUNT, 0);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // 在应用关闭时清理
        ServletContext context = sce.getServletContext();
        context.removeAttribute(ONLINE_USERS);
        context.removeAttribute(ONLINE_COUNT);
    }
    
    @Override
    public void sessionCreated(HttpSessionEvent se) {
        HttpSession session = se.getSession();
        ServletContext context = session.getServletContext();
        
        // 使用ConcurrentHashMap存储在线用户
        ConcurrentHashMap<String, Long> onlineUsers = getOnlineUsers(context);
        
        // 只有登录用户才计数
        if (session.getAttribute("user") != null) {
            onlineUsers.put(session.getId(), System.currentTimeMillis());
            updateOnlineCount(context, onlineUsers.size());
        }
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        HttpSession session = se.getSession();
        ServletContext context = session.getServletContext();
        
        ConcurrentHashMap<String, Long> onlineUsers = getOnlineUsers(context);
        onlineUsers.remove(session.getId());
        updateOnlineCount(context, onlineUsers.size());
    }
    
    @SuppressWarnings("unchecked")
    private ConcurrentHashMap<String, Long> getOnlineUsers(ServletContext context) {
        ConcurrentHashMap<String, Long> onlineUsers = 
            (ConcurrentHashMap<String, Long>) context.getAttribute(ONLINE_USERS);
        
        if (onlineUsers == null) {
            synchronized (this) {
                onlineUsers = (ConcurrentHashMap<String, Long>) context.getAttribute(ONLINE_USERS);
                if (onlineUsers == null) {
                    onlineUsers = new ConcurrentHashMap<>();
                    context.setAttribute(ONLINE_USERS, onlineUsers);
                    context.setAttribute(ONLINE_COUNT, 0);
                }
            }
        }
        return onlineUsers;
    }
    
    private void updateOnlineCount(ServletContext context, int count) {
        context.setAttribute(ONLINE_COUNT, count);
        System.out.println("Current Online Users: " + count + ", Sessions: " + 
            ((ConcurrentHashMap<?, ?>)context.getAttribute(ONLINE_USERS)).keySet());
    }
} 