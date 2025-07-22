USE help_desk;

-- Listar empresas e solicitantes das mesmas e lembrando que apenas as que possuem solicitantes
CALL ListarEmpresasESolicitantes();

-- Fechar um chamado quando ele for igual a fechado
CALL FecharChamado(5);
CALL FecharChamado(18);

-- criando um chamado que deseja
CALL CriarChamado(
    'Erro na hora de clicar no botão',
    'estou com um problema na hora de clicar no botão, ele fica dando erro',
    2,         -- status_id (ex: 2 = Em espera, 1 = aberto, 3 = finalizado )
    3,         -- sla_id (60min resposta / 240min solução)
    1,         -- tipo_servico_id (Manutenção)
    1,         -- subtipo_id (Reparo de impressora, por exemplo)
    2,         -- solicitante_id (João Silva da empresa Tech Solutions)
    1          -- tecnico_id (João Silva técnico)
);
CALL FecharChamado(1);

CALL AtualizarStatusChamado(1, 4, 'Chamado encerrado pelo técnico.');

-- Removendo um chamado
CALL RemoverChamado(18);

-- Buscando pela palavra energia (busca dentro do conteúdo da base)
CALL BuscarBasePorPalavra('Energia');

-- Atualizando o status do chamado e colocando uma mensagem no historico
CALL AtualizarStatusChamado(18, 1, 'Alterado para Aberto');
CALL AtualizarStatusChamado(18, 2, 'Alterado para Em espera');
CALL AtualizarStatusChamado(18, 3, 'Alterado para Em andamento');
CALL AtualizarStatusChamado(18, 4, 'Alterado para Finalizado');

-- listando os chamados pelo solicitante, no caso 
CALL ListarChamadosPorSolicitante(1);


-- editando o usuário com ID 2
CALL EditarUsuario(2,'Maria Souza','mariasouza@email.com','novasenha123','999998888');

-- remove o usuário com ID 4
CALL RemoverUsuario(4); 

-- inserindo um usuário no sistema
CALL InserirUsuarioNoSistema('Ana Lima', 'ana@email.com', 'senha123', '999999998');

-- buscando chamados por status aberto neste caso
CALL ListarChamadosPorStatus('Aberto');
CALL ListarChamadosPorStatus('Em espera');
CALL ListarChamadosPorStatus('Em andamento');
CALL ListarChamadosPorStatus('Fechado');

