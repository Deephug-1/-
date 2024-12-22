package com.lab.utils;

import com.alibaba.druid.pool.DruidDataSourceFactory;

import javax.sql.DataSource;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

/**
 * 创建数据源-获取数据连接
 */
public class DbUtil {
    private static Properties properties = new Properties();
    private static DataSource dataSource = null;
    
    static {
        try {
            InputStream resourceAsStream = 
                DbUtil.class.getClassLoader()
                    .getResourceAsStream("dbconfig.properties");
            //将配置文件中的内容加载到properties对象中
            properties.load(resourceAsStream);
            //根据配置对象信息创建连接池对象
            dataSource = DruidDataSourceFactory.createDataSource(properties);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    //获取连接对象
    public static Connection getConnection() throws SQLException {
        Connection connection = dataSource.getConnection();
        return connection;
    }

    //释放连接资源
    public static void close(Statement statement, ResultSet resultSet)
            throws SQLException {
        if(statement != null){
            statement.close();
        }
        if(resultSet != null){
            resultSet.close();
        }
    }
}
