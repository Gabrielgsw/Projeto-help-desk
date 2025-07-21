USE help_desk;

-- Listar empresas e solicitantes das mesmas e lembrando que apenas as que possuem solicitantes
CALL ListarEmpresasESolicitantes();

-- Fechar um chamado quando ele for igual a fechado
CALL FecharChamado(5);

-- criando um chamado que deseja
CALL CriarChamado(
    'Erro ao acessar sistema (teste555)',
    'Usuário recebe mensagem de "acesso negado" ao tentar entrar no sistema ERP. (teste234343432)',
    2,         -- status_id (ex: 2 = Em espera)
    1,         -- sla_id (60min resposta / 240min solução)
    1,         -- tipo_servico_id (Manutenção)
    1,         -- subtipo_id (Reparo de impressora, por exemplo)
    1,         -- solicitante_id (João Silva da empresa Tech Solutions)
    1          -- tecnico_id (João Silva técnico)
);


-- Removendo um chamado
CALL RemoverChamado(3);

-- Buscando pela palavra energia
CALL BuscarBasePorPalavra('energia');

-- Atualizando o status do chamado e colocando uma mensagem no historico
CALL AtualizarStatusChamado(1, 3, 'Alterado para Em andamento');

-- listando os chamados pelo solicitante 2, no caso 
CALL ListarChamadosPorSolicitante(1);

-- editando o usuário com ID 2
CALL EditarUsuario(2,'Maria Souza','mariasouza@email.com','novasenha123','999998888');

-- remove o usuário com ID 4
CALL RemoverUsuario(4); 

-- inserindo um usuário no sistema
CALL InserirUsuarioNoSistema('Ana Lima', 'ana@email.com', 'senha123', '999999998');

-- buscando chamados por status aberto neste caso
CALL ListarChamadosPorStatus('Em espera');

