CREATE USER IF NOT EXISTS 'imathas'@'%' IDENTIFIED WITH caching_sha2_password BY 'imathas';
GRANT USAGE ON *.* to 'imathas'@'%';
GRANT PROCESS ON *.* TO 'imathas'@'%';
FLUSH PRIVILEGES;
