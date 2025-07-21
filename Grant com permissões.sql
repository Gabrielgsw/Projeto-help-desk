USE help_desk;

-- Um cliente pode registrar chamados, enviar comentários, dar feedback e consultar seus dados
GRANT SELECT ON Chamado TO CLIENTE;
GRANT INSERT ON Chamado TO CLIENTE;
GRANT INSERT, SELECT ON Comentario TO CLIENTE;
GRANT INSERT, SELECT ON Feedback TO CLIENTE;

-- Um técnico pode gerenciar chamados e logs
GRANT SELECT, UPDATE ON Chamado TO TECNICO;
GRANT INSERT, SELECT ON Comentario TO TECNICO;
GRANT INSERT, SELECT ON Historico TO TECNICO;
GRANT INSERT, SELECT ON Auditoria TO TECNICO;
GRANT INSERT, SELECT ON LogAtividades TO TECNICO;
GRANT INSERT, SELECT ON TempoAtividade TO TECNICO;

-- Um supervisor pode ver tudo e atualizar base de conhecimento
GRANT SELECT ON * TO SUPERVISOR;
GRANT INSERT, UPDATE ON BaseConhecimento TO SUPERVISOR;
GRANT INSERT, UPDATE ON PalavraChave TO SUPERVISOR;

GRANT USAGE ON help_desk.* TO CLIENTE;
GRANT USAGE ON help_desk.* TO TECNICO;
GRANT USAGE ON help_desk.* TO SUPERVISOR;

-- Para que as alterações de privilégio entrem em vigor imediatamente
FLUSH PRIVILEGES;