Create DATABASE Tech4Work;
USE Tech4Work;

CREATE TABLE clientes (
	id Int auto_increment primary KEY,
    nome varchar(50),
    email varchar(50),
    tipo ENUM('Pessoa Física', 'Empresa'),
    cpf_cnpj varchar(20),
	cidade varchar(50),
    estado varchar(2)
);

CREATE TABLE categorias (
	id int auto_increment primary key,
    nome varchar(50)
);

CREATE TABLE produtos (
	id int auto_increment primary key,
    nome varchar(100),
    descricao TEXT,
    preco DECIMAL(10, 2),
    estoque int default 0,
    id_categoria int,
    foreign key (id_categoria) REFERENCES categorias(id)
);

Create table vendedores (
	id int auto_increment primary key,
    nome VARCHAR(100),
    canal ENUM('Online', 'Revenda', 'B2B'),
    regiao varchar(50)
);

CREATE TABLE vendas (
	id int auto_increment primary key,
    data DATE,
    id_cliente int,
    id_produto int,
    id_vendedor int,
    quantidade int,
    foreign key (id_cliente) REFERENCES clientes(id),
	foreign key (id_produto) REFERENCES produtos(id),
	foreign key (id_vendedor) REFERENCES vendedores(id)
);

CREATE TABLE kits (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    preco DECIMAL(10,2)
);

CREATE TABLE kit_itens (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_kit INT,
    id_produto INT,
    quantidade INT,
    FOREIGN KEY (id_kit) REFERENCES kits(id),
    FOREIGN KEY (id_produto) REFERENCES produtos(id)
);

CREATE TABLE vendas_itens (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_venda INT,
    id_produto INT,
    tipo_item ENUM('produto', 'kit') DEFAULT 'produto',
    quantidade INT,
    preco_unitario DECIMAL(10, 2),
    FOREIGN KEY (id_venda) REFERENCES vendas(id),
    FOREIGN KEY (id_produto) REFERENCES produtos(id)
);

INSERT INTO categorias (nome) values
	('Monitores'),
    ('Periféricos'),
    ('Áudio'),
    ('Mobiliário'),
    ('Acessórios')
;

INSERT INTO produtos (nome, descricao, preco, estoque, id_categoria) VALUES
	('Monitor 27" Full HD', 'Monitor com tela IPS e taxa de 75Hz', 1200.00, 30, 1),
	('Mouse Ergonômico Wireless', 'Design anatômico e conexão USB', 150.00, 50, 2),
	('Teclado Mecânico RGB', 'Switchs azuis, ideal para digitação', 280.00, 40, 2),
	('Headset Bluetooth com Microfone', 'Cancelamento de ruído e bateria de 20h', 300.00, 35, 3),
	('Cadeira Gamer TechPro', 'Apoio lombar e ajuste de altura', 950.00, 25, 4),
	('Mesa Ajustável Elétrica', 'Altura regulável com motor silencioso', 1800.00, 15, 4),
	('Suporte para Notebook', 'Com ventilação e inclinação ajustável', 120.00, 60, 5),
	('Hub USB-C 6 em 1', 'Expansão de portas com HDMI e USB', 180.00, 45, 5),
	('Webcam Full HD', 'Ideal para videoconferência', 220.00, 40, 3),
	('Teclado e Mouse Combo Wireless', 'Economia e praticidade para escritório', 210.00, 55, 2)
;

INSERT INTO clientes (nome, email, tipo, cpf_cnpj, cidade, estado) VALUES
	('Empresa Alfa Ltda', 'contato@alfa.com.br', 'Empresa', '12.345.678/0001-99', 'São Paulo', 'SP'),
	('Carlos Henrique', 'carlos.henrique@gmail.com', 'Pessoa Física', '123.456.789-00', 'Belo Horizonte', 'MG'),
	('Startup Beta', 'beta@startup.com', 'Empresa', '45.678.912/0001-22', 'Curitiba', 'PR'),
	('Juliana Dias', 'juliana.dias@gmail.com', 'Pessoa Física', '987.654.321-00', 'Porto Alegre', 'RS'),
	('TechOne Soluções', 'vendas@techone.com', 'Empresa', '32.198.456/0001-66', 'Florianópolis', 'SC')
;

INSERT INTO vendedores (nome, canal, regiao) VALUES
	('Marcos Silva', 'B2B', 'Sudeste'),
	('Patrícia Gomes', 'Online', 'Sul'),
	('Rafael Tavares', 'Revenda', 'Centro-Oeste'),
	('Fernanda Lima', 'Online', 'Nordeste'),
	('João Pedro Oliveira', 'B2B', 'Sul')
;

INSERT INTO vendas (data, id_cliente, id_produto, id_vendedor, quantidade) VALUES
	-- Cliente 1 (Empresa Alfa)
	('2025-06-10', 1, 1, 1, 2), -- 2x Monitor 27"
	('2025-06-11', 1, 2, 1, 5), -- 5x Mouse

	-- Cliente 2 (Carlos)
	('2025-06-12', 2, 3, 2, 1), -- 1x Teclado Mecânico
	('2025-06-13', 2, 9, 2, 1), -- 1x Webcam

	-- Cliente 3 (Startup Beta)
	('2025-07-01', 3, 4, 3, 3), -- 3x Headset
	('2025-07-02', 3, 5, 3, 1), -- 1x Cadeira Gamer

	-- Cliente 4 (Juliana)
	('2025-07-05', 4, 7, 2, 2), -- 2x Suporte p/ Notebook
	('2025-07-06', 4, 8, 2, 1), -- 1x Hub USB-C

	-- Cliente 5 (TechOne)
	('2025-07-10', 5, 6, 5, 2), -- 2x Mesa Elétrica
	('2025-07-11', 5, 10, 5, 5); -- 5x Combo Teclado + Mouse

CREATE OR REPLACE VIEW vw_resumo_vendas AS
SELECT 
    v.id AS id_venda,
    v.data AS data_venda,
    c.nome AS cliente,
    p.nome AS produto,
    vi.quantidade,
    vi.preco_unitario,
    (vi.quantidade * vi.preco_unitario) AS valor_total
FROM vendas v
JOIN clientes c ON v.id_cliente = c.id
JOIN vendas_itens vi ON v.id = vi.id_venda
JOIN produtos p ON vi.id_produto = p.id;

INSERT INTO vendas_itens (id_venda, id_produto, tipo_item, quantidade, preco_unitario)
SELECT
	v.id,
    v.id_produto,
    'produto',
    v.quantidade,
    p.preco
FROM vendas v
JOIN produtos p ON v.id_produto = p.id;
    
INSERT INTO vendas (data, id_cliente, id_produto, id_vendedor, quantidade) VALUES 
	('2025-07-11', 2, 3, 1, 2);

INSERT INTO vendas_itens (id_venda, id_produto, tipo_item, quantidade, preco_unitario) VALUES 
	(11, 3, 'produto', 2, 280.00);

INSERT INTO produtos (nome, descricao, preco, estoque, id_categoria) VALUES 
	('Mouse Ergonômico Wireless', 'Mouse sem fio', 150.00, 50, 1),
	('Teclado Mecânico RGB', 'Teclado com iluminação', 280.00, 40, 1);

INSERT INTO kits (id, nome, preco) VALUES 
	(3, 'Kit Teclado + Mouse', 400.00);

INSERT INTO kit_itens (id_kit, id_produto, quantidade) VALUES 
	(3, 2, 1),  -- 1x Mouse
	(3, 3, 1);  -- 1x Teclado

SELECT * FROM kit_itens WHERE id_kit = 3;

CALL registrar_venda_kit(1, 3, 2);
CALL registrar_venda_kit(1, 3, 2);

SELECT * FROM vendas_itens WHERE id_venda = 1;
SELECT id, nome, estoque FROM produtos WHERE id IN (2, 3);

UPDATE vendas_itens vi
JOIN kits k ON vi.id_produto = k.id
SET vi.preco_unitario = k.preco
WHERE vi.tipo_item = 'kit' AND vi.preco_unitario IS NULL;

SELECT * FROM vendas_itens WHERE id_venda = 1;






























































