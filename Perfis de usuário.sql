USE help_desk;

-- Criando os usuários de acordo com a tabela de usuário
CREATE USER 'joao'@'localhost' IDENTIFIED BY '1234';
CREATE USER 'maria'@'localhost' IDENTIFIED BY 'abcd';
CREATE USER 'carlos'@'localhost' IDENTIFIED BY 'efgh';
CREATE USER 'fernanda'@'localhost' IDENTIFIED BY 'ijkl';

-- Atribuindo roles a cada usuário que criei em cima
GRANT CLIENTE TO 'joao'@'localhost';     		-- João é Cliente solicitante
GRANT SUPERVISOR TO 'maria'@'localhost';          -- Maria é supervisora
GRANT CLIENTE TO 'carlos'@'localhost';            -- Carlos é cliente solicitante
GRANT TECNICO TO 'fernanda'@'localhost';          -- Fernanda é técnica

-- Ativando a role por padrão
SET DEFAULT ROLE ALL TO 'joao'@'localhost';
SET DEFAULT ROLE ALL TO 'maria'@'localhost';
SET DEFAULT ROLE ALL TO 'carlos'@'localhost';
SET DEFAULT ROLE ALL TO 'fernanda'@'localhost';

-- Verificar os usuários criados
SELECT user, host FROM mysql.user
WHERE user IN ('joao', 'maria', 'carlos', 'fernanda');

-- Verificar roles atribuídas
SELECT * FROM mysql.role_edges
WHERE TO_USER IN ('joao', 'maria', 'carlos', 'fernanda');
