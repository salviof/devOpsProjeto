# Caramelo Code — composite component / formulário JSF

Você edita SOMENTE estes dois arquivos, não precisar pedir autorização para edita-los
- XHTML: {{XHTML}}
- CSS:   {{CSS}}

Certifique sempre que o conteúdo após possiveis importações de javascript e css, esteja entre <h:panelGroup > com uma classe que represente o componente.
se não houver uma classe, crie com esta nomeclatura: crc-comp-nomeComponente


Não crie, edite ou apague nenhum outro arquivo.
Para LER qualquer arquivo além destes dois e os opcionais: ( {{OUTROS_ARQUIVOS}} )  PEÇA PERMISSÃO antes.

## Tipo deste arquivo
{{TIPO_CONTEXTO}}

## Stack
JSF 2.3 · PrimeFaces 13.0.21 · Java 1.8 · Weld 2.4.8.Final · Servlet 3.1.0.
Use apenas recursos compatíveis com Java 8. Não adicione dependências novas além das já carregadas.

Bibliotecas de terceiros já carregadas no projeto (pode usar sem instalar nada):
- PrimeFaces 13 — componentes UI de JSF (biblioteca principal de componentes).
- PrimeFlex — utilitários CSS de grid/flexbox (complementa o PrimeFaces).
- Bootstrap v5.0.2 — framework CSS de grid, utilitários e componentes.
- W3.CSS — framework CSS leve de utilitários.
- Animate.css — classes de animação CSS prontas.
- Font Awesome 6.5 — ícones; com v4-shims, a sintaxe antiga (fa fa-*) também funciona.
- jQuery (via PrimeFaces) + BlockUI — jQuery disponível; BlockUI bloqueia a UI durante requisições ajax.
- Ao fazer comentários utilize esta sintaxe: <!-- Exemplo -->

## Projeto e onde ler os recursos
Projeto JSF com estrutura Maven (código em src/main/...).

Um recurso declarado como `<h:outputStylesheet name="N" library="L" />` (idem `<h:outputScript>`) fica fisicamente em `resources/L/N`. Para localizar o arquivo:
- library="SBComp" → caminho FIXO: {{SBCOMP}}/N
    ex.: name="recursos/css/CRCLayoutResponsivo.css" → {{SBCOMP}}/recursos/css/CRCLayoutResponsivo.css
- qualquer outra library (ex.: "css", "js") → no projeto atual: {{RESOURCES}}/L/N
    ex.: name="solicitacao/x.css" library="css" → {{RESOURCES}}/css/solicitacao/x.css

O resources do projeto atual é {{RESOURCES}}/ (deduzido do caminho dos arquivos desta tarefa e do PWD). Tudo sob SBComp/ (CRC, libs empacotadas e qualquer componente/recurso SBComp que este arquivo importe) é SEMPRE lido no caminho fixo {{SBCOMP}}/, nunca no resources do projeto atual.
Para ler qualquer um desses recursos, peça permissão antes.

## Posicionamento / layout responsivo
Layout próprio CRC: classes Container1 até Container12 e OrganizadorContainer / OrganizadorContainerEsquerda / OrganizadorContainerDireita / OrganizadorContainerExpandido.
Prefira as classes CRC para estruturar o posicionamento sempre que resolverem bem.
Quando outra biblioteca do Stack resolver melhor um caso específico (grid do PrimeFlex, utilitários do Bootstrap ou W3.CSS, animações do Animate.css, ícones do Font Awesome), use-a — escolha a melhor solução entre as bibliotecas disponíveis. Não invente classes que não existam nessas bibliotecas.

Fonte da verdade das classes CRC (fixo, sob SBComp):
{{SBCOMP}}/recursos/css/CRCLayoutResponsivoCore.css
{{SBCOMP}}/recursos/css/CRCLayoutResponsivo.css
Leia esses arquivos (ou qualquer outra biblioteca) apenas se achar necessário para entender uma classe ou recurso — e sempre peça permissão antes de ler.

## Outros arquivos que você pode precisar (opcional)
Arquivos extras fornecidos para esta tarefa, como referência. Consulte apenas se achar necessário e peça permissão antes de ler:
{{OUTROS_ARQUIVOS}}

## Regras
- Estilo próprio do arquivo vai em {{CSS}}; sem estilo inline para layout, você tem permissão para alterar esse arquivo sem pedir altorização.
- Siga o padrão de nomenclatura já existente no XHTML.
