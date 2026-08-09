SEMEF MANAUS — VERSÃO PWA + SINCRONIZAÇÃO

PASSO 1 — INSTALAR VS CODE
1. Instale o Visual Studio Code.
2. Extraia esta pasta.
3. Abra a pasta no VS Code.

PASSO 2 — CRIAR O SUPABASE
1. Crie uma conta em supabase.com.
2. Crie um novo projeto.
3. Abra SQL Editor.
4. Cole todo o conteúdo de supabase.sql e execute.
5. Vá em Project Settings > API e copie a Project URL e a chave publicável (publishable key).

PASSO 3 — CONFIGURAR O APP
1. Abra index.html.
2. Procure SUPABASE_URL e SUPABASE_KEY.
3. Cole os dois valores.
4. Salve.

PASSO 4 — TESTAR
O arquivo HTML não deve ser aberto por duplo clique para testar PWA. Use um servidor local.
Se tiver Python instalado, na pasta do projeto execute:
python -m http.server 8000
Depois abra http://localhost:8000

PASSO 5 — CONTA
No primeiro uso, crie uma conta de e-mail e senha no Supabase Auth (Authentication > Users > Add user), ou podemos acrescentar um botão de cadastro na próxima etapa.

IMPORTANTE
- O app continua funcionando offline.
- localStorage continua guardando o progresso local.
- O botão Sincronizar envia/recupera progresso e itens pessoais.
- A parte de sincronizar o conteúdo-base (conteudo.json) será feita na próxima etapa, para você poder editar o JSON no PC e atualizar todos os aparelhos.
