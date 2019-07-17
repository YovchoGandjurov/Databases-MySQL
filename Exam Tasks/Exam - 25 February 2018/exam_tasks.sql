CREATE DATABASE buhtig;
USE buhtig;


# Section 1: Data Definition Language (DDL) – 40 pts

CREATE TABLE users (
	id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(30) UNIQUE NOT NULL,
    password VARCHAR(30) NOT NULL,
    email VARCHAR(50) NOT NULL
);


CREATE TABLE repositories (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);


CREATE TABLE repositories_contributors (
	repository_id INT,
    contributor_id INT,
    CONSTRAINT fk_repositories_users_repo
    FOREIGN KEY (repository_id) REFERENCES repositories(id),
    CONSTRAINT fk_repositories_users_user
    FOREIGN KEY (contributor_id) REFERENCES users(id)
);


CREATE TABLE issues (
	id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    issue_status VARCHAR(6) NOT NULL,
    repository_id INT NOT NULL,
    assignee_id INT NOT NULL,
    CONSTRAINT fk_issues_repos
    FOREIGN KEY (repository_id) REFERENCES repositories(id),
    CONSTRAINT fk_issues_users
    FOREIGN KEY (assignee_id) REFERENCES users(id)
);


CREATE TABLE commits (
	id INT PRIMARY KEY AUTO_INCREMENT,
    message VARCHAR(255) NOT NULL,
    issue_id INT,
    repository_id INT NOT NULL,
    contributor_id INT NOT NULL,
    CONSTRAINT fk_commits_issues
    FOREIGN KEY (issue_id) REFERENCES issues(id),
    CONSTRAINT fk_commits_repos
    FOREIGN KEY (repository_id) REFERENCES repositories(id),
    CONSTRAINT fk_commits_users
    FOREIGN KEY (contributor_id) REFERENCES users(id)
);


CREATE TABLE files (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    size DECIMAL(10, 2) NOT NULL,
    parent_id INT,
    commit_id INT NOT NULL,
    CONSTRAINT fk_files_parents
    FOREIGN KEY (parent_id) REFERENCES files(id),
    CONSTRAINT fk_files_commits
    FOREIGN KEY (commit_id) REFERENCES commits(id)
);



# Section 2: Data Manipulation Language (DML) – 30 pts

# 02. Data Insertion

INSERT INTO issues (title, issue_status, repository_id, assignee_id)
SELECT
	CONCAT('Critical Problem With ', f.name, '!') AS title,
    'open' AS issue_status,
    CEILING(f.id* 2 / 3) AS repository_id,
    c.contributor_id AS assignee_id
FROM files f
JOIN commits c
ON c.id = f.commit_id
WHERE f.id BETWEEN 46 AND 50;
	


#03. Data Update
# UPDATE 


# 04. Data Deletion
DELETE FROM repositories
WHERE id NOT IN (
	SELECT repository_id FROM issues
);


#05. Users
SELECT id, username FROM users
ORDER BY id;


#06. Lucky Numbers
SELECT repository_id, contributor_id
FROM repositories_contributors
WHERE repository_id = contributor_id
ORDER BY repository_id;


#07. Heavy HTML
SELECT id, name, size
FROM files
WHERE size > 1000 AND name LIKE '%html'
ORDER BY size DESC;


#08. Issues and Users
SELECT i.id, CONCAT(u.username, ' : ', i.title) AS issue_assignee
FROM issues i
JOIN users u
ON i.assignee_id = u.id
ORDER BY i.id DESC;


#09. Non-Directory Files
SELECT f2.id, f2.name AS Name, CONCAT(f2.size, 'KB') AS size
FROM files f1
RIGHT JOIN files f2
ON f1.parent_id = f2.id
WHERE f1.id IS NULL
ORDER BY f2.id;


#10. Active Repositories
SELECT r.id, r.name, COUNT(i.repository_id) AS issues
FROM repositories r
JOIN issues i
ON r.id = i.repository_id
GROUP BY r.name
ORDER BY issues DESC, r.id
LIMIT 5;


#11. Most Contributed Repository

SELECT
	r.id,
    r.name,
    (SELECT COUNT(*) FROM commits WHERE commits.repository_id = r.id) AS commits,
    COUNT(rc.repository_id) AS contributors
FROM users u
JOIN repositories_contributors rc
ON u.id = rc.contributor_id
JOIN repositories r
ON rc.repository_id = r.id
GROUP BY r.name
ORDER BY contributors DESC, r.id
LIMIT 1;


#12. Fixing My Own Problems
SELECT
	u.id,
    u.username,
    COUNT(c.id) AS commits
FROM users u

LEFT JOIN issues i
ON u.id = i.assignee_id

LEFT JOIN commits c
ON c.issue_id = i.id AND c.contributor_id = u.id

GROUP BY u.username
ORDER BY commits DESC, u.id;


#13. Recursive Commits
SELECT
	SUBSTRING_INDEX(f1.name, '.' , 1) AS file,
    (SELECT COUNT(*) FROM commits c WHERE message LIKE CONCAT('%',file,'%')) AS recursive_count
FROM files f1
JOIN files f2
ON f1.parent_id = f2.id
JOIN commits c
ON f2.commit_id = c.id
WHERE f1.id = f2.parent_id AND f2.id = f1.parent_id AND f1.id != f1.parent_id
GROUP BY f1.name;


#14. Repositories and Commits
 SELECT r.id, r.name, COUNT(DISTINCT  c.contributor_id) AS users
 FROM repositories r
 LEFT JOIN commits c
 ON r.id = c.repository_id
 GROUP BY r.id
 ORDER BY users DESC, r.id ASC;





































