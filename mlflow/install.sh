mlflow server --backend-store-uri /mnt/persistent-disk   --host 0.0.0.0 --port 8089 --default-artifact-root s3://my-mlflow-bucket/

# mysql和minIO都搭建好后，配置好minIO client的访问配置信息后，后台启动mlflow
nohup mlflow server --backend-store-uri mysql://root:123456@192.168.0.1:3306/mlflow_test --host 0.0.0.0 --port 5000 --default-artifact-root s3://mlflow &

export AWS_ACCESS_KEY_ID=ccnlminiio
export AWS_SECRET_ACCESS_KEY=passwordhhh
export MLFLOW_S3_ENDPOINT_URL=http://192.168.0.1:9033

# 1.安装minIO: https://min.io/docs/minio/container/index.html
docker run -it -p 9033:9000 -p 9094:9090 -d --name minio -v /data/minio:/data -e "MINIO_ROOT_USER=ccnlminiio" -e "MINIO_ROOT_PASSWORD=passwordhhh" quay.io/minio/minio server /data --console-address ":9090" 

# minIO访问地址:
# http://192.168.0.1:9094

# 2.安装mysql
# （1）方式一：docker安装
    docker run -itd --name MySQL -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 mysql:8.2
    # root登录数据库
    docker exec -it MySQL /bin/bash
    # 进入数据库容器
    # mysql -u root -p (密码输入123456)
    # 创建其他用户并授予权限
    # -- 创建数据库
    # CREATE DATABASE mlflow_test;
    # -- 创建用户
    # CREATE USER 'newuser'@'%' IDENTIFIED BY 'newuserpassword';
    # -- 授予newuser数据库testdb的所有权限
    # GRANT ALL PRIVILEGES ON mlflow_test.* TO 'newuser'@'%';
    # -- 使权限生效
    # FLUSH PRIVILEGES;

# （2）方式二：本地安装
    apt-get install mysql-server
    mysql --versionsudo mysql
    # 启动
    sudo mysql
    # 设置root用户密码，并让其他任何主机用root和密码连接到mysql服务器
    ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY '123456';
    update mysql.user  set host = '%' where user = 'root'; 
    SELECT user,authentication_string,plugin,host FROM mysql.user;
    ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '123456';
    flush privileges;

    vim /etc/mysql/mysql.conf.d/mysqld.cnf
    注释 bind-address         = 127.0.0.1
    #  bind-address         = 127.0.0.1



