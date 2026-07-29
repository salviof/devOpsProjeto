# Caramelo Code — composite component JSF

Você edita SOMENTE estes dois arquivos:
- XHTML: {{XHTML}}
- CSS:   {{CSS}}

Não crie, edite ou apague nenhum outro arquivo.
Para LER qualquer arquivo além destes dois, PEÇA PERMISSÃO antes.

## Stack
JSF 2.3 (composite components) · PrimeFaces 13.0.21 · Java 1.8 · Weld 2.4.8.Final · Servlet 3.1.0.
Use apenas recursos compatíveis com Java 8. Não adicione dependências novas além das já carregadas.

Bibliotecas de terceiros já carregadas no projeto (pode usar sem instalar nada):
- PrimeFaces 13 — componentes UI de JSF (biblioteca principal de componentes).
- PrimeFlex — utilitários CSS de grid/flexbox (complementa o PrimeFaces).
- Bootstrap — framework CSS de grid, utilitários e componentes.
- W3.CSS — framework CSS leve de utilitários.
- Animate.css — classes de animação CSS prontas.
- Font Awesome 6.5 — ícones; com v4-shims, a sintaxe antiga (fa fa-*) também funciona.
- jQuery (via PrimeFaces) + BlockUI — jQuery disponível; BlockUI bloqueia a UI durante requisições ajax.

## Projeto e onde ler os recursos
Projeto JSF com estrutura Maven (código em src/main/...). Regras de caminho:
- Tudo sob SBComp/ tem caminho FIXO: {{SBCOMP}}/ — inclui o CRC, as libs empacotadas e QUALQUER componente ou recurso SBComp que este componente importe. Leia-os sempre nesse caminho fixo, nunca no resources do projeto atual.
- O componente atual e os demais recursos do projeto (ex.: library "css", "js") são RELATIVOS ao resources do projeto atual: {{RESOURCES}}/
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
- Estilo próprio do componente vai em {{CSS}}; sem estilo inline para layout.
- Siga o padrão de nomenclatura já existente no XHTML.
