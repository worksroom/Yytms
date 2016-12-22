#Yytms
##1、运行环境
	JDK1.7+
	MYSQL 5.0+
	Tomcat7+
##2、开发环境
	Gradle2.3+
	IntelliJIDEA 14.0.2
	Navicat for MySQL
##3、安装
	创建数据库，名称lakeside，字符集UTF-8
	导入表结构和初始化数据，Yytms/doc/database.sql
	安装JDK
	安装Tomcat 将编译后的Yytms目录拷贝到tomcat/webapps目录下
##4、运行
	启动tomcat 执行启动脚本startup.sh
	通过浏览器访问http://ip:8080/lakeside/