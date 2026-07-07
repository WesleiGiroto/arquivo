Card Faturamento HTML WAFFLE = 

-- ╔══════════════════════════════════════════════════════════════════╗
-- ║                  🎨 PAINEL DE CONTROLE VISUAL                   ║
-- ║   Ajuste os parâmetros abaixo sem mexer na lógica da medida      ║
-- ╚══════════════════════════════════════════════════════════════════╝


-- ──────────────────────────────────────────────────────────────────
-- 🔎 ESCALA GERAL
-- ──────────────────────────────────────────────────────────────────

VAR EscalaConteudoPercentual = 55
VAR EscalaCardPercentual = 55

VAR FatorEscalaConteudo = DIVIDE(EscalaConteudoPercentual, 100)
VAR FatorEscalaCard = DIVIDE(EscalaCardPercentual, 100)


-- ──────────────────────────────────────────────────────────────────
-- 🔤 FONTES
-- ──────────────────────────────────────────────────────────────────

VAR fonte_principal = "Poppins, Segoe UI, Arial, sans-serif"


-- ──────────────────────────────────────────────────────────────────
-- 📝 TEXTOS DO CARD
-- ──────────────────────────────────────────────────────────────────

VAR titulo_card = "Receita Mensal"
VAR texto_comparativo = "vs ano ant."


-- ──────────────────────────────────────────────────────────────────
-- 📦 CARD / CONTAINER
-- ──────────────────────────────────────────────────────────────────

VAR largura_card = ROUND(610 * FatorEscalaCard, 0) & "px"
VAR altura_card = ROUND(308 * FatorEscalaCard, 0) & "px"
VAR raio_borda = ROUND(34 * FatorEscalaCard, 0) & "px"
VAR padding_card = ROUND(38 * FatorEscalaCard, 0) & "px"

VAR cor_fundo_card = "#FFFFFF"
VAR cor_borda_card = "#E8EAF2"

VAR ExibirSombraCard = FALSE()
VAR sombra_card =
    IF(
        ExibirSombraCard,
        "0 18px 38px rgba(15, 23, 42, 0.10)",
        "none"
    )


-- ──────────────────────────────────────────────────────────────────
-- 🎨 CORES GERAIS
-- ──────────────────────────────────────────────────────────────────

VAR cor_titulo = "#8A8F9C"
VAR cor_valor = "#1F2937"
VAR cor_texto_secundario = "#8A8F9C"

VAR cor_positivo = "#16C79A"
VAR cor_negativo = "#F43F5E"

VAR cor_icone_fundo = "#F4F6FB"
VAR cor_icone = "#8A8F9C"

VAR cor_waffle_vazio = "#E8EEF5"

VAR cor_badge_fundo_positivo = "#DFFBF0"
VAR cor_badge_fundo_negativo = "#FFE4E6"


-- ──────────────────────────────────────────────────────────────────
-- 🏷️ TÍTULO
-- ──────────────────────────────────────────────────────────────────

VAR fonte_titulo = fonte_principal
VAR peso_titulo = "700"
VAR tamanho_titulo = ROUND(28 * FatorEscalaConteudo, 0) & "px"


-- ──────────────────────────────────────────────────────────────────
-- 💰 VALOR PRINCIPAL
-- ──────────────────────────────────────────────────────────────────

VAR fonte_valor = fonte_principal
VAR peso_valor = "700"
VAR tamanho_valor = ROUND(56 * FatorEscalaConteudo, 0) & "px"
VAR espacamento_letra_valor = "-2.4px"


-- ──────────────────────────────────────────────────────────────────
-- 📊 BADGE DE VARIAÇÃO VS MÊS ANTERIOR
-- ──────────────────────────────────────────────────────────────────

VAR fonte_label_comparativo = fonte_principal
VAR peso_label_comparativo = "700"
VAR tamanho_label_comparativo = ROUND(22 * FatorEscalaConteudo, 0) & "px"

VAR padding_badge_vertical = ROUND(10 * FatorEscalaConteudo, 0) & "px"
VAR padding_badge_horizontal = ROUND(18 * FatorEscalaConteudo, 0) & "px"
VAR raio_badge = ROUND(18 * FatorEscalaConteudo, 0) & "px"


-- ──────────────────────────────────────────────────────────────────
-- 🎯 BLOCO DE META / WAFFLE
-- ──────────────────────────────────────────────────────────────────

VAR fonte_label_meta = fonte_principal
VAR peso_label_meta = "700"
VAR tamanho_label_meta = ROUND(16 * FatorEscalaConteudo, 0) & "px"

VAR fonte_percentual_meta = fonte_principal
VAR peso_percentual_meta = "700"
VAR tamanho_percentual_meta = ROUND(38 * FatorEscalaConteudo, 0) & "px"

VAR largura_bloco_meta = ROUND(190 * FatorEscalaConteudo, 0) & "px"

VAR qtd_bolinhas = 25
VAR tamanho_bolinha = ROUND(16 * FatorEscalaConteudo, 0) & "px"
VAR gap_bolinha = ROUND(10 * FatorEscalaConteudo, 0) & "px"


-- ──────────────────────────────────────────────────────────────────
-- 💲 ÍCONE SVG
-- ──────────────────────────────────────────────────────────────────

VAR ExibirIcone = TRUE()

VAR tamanho_icone_box = ROUND(58 * FatorEscalaConteudo, 0) & "px"
VAR tamanho_icone_svg = ROUND(30 * FatorEscalaConteudo, 0) & "px"
VAR raio_icone = ROUND(18 * FatorEscalaConteudo, 0) & "px"

VAR IconeSVG =
    IF(
        ExibirIcone,
        "<div style='
            width:" & tamanho_icone_box & ";
            height:" & tamanho_icone_box & ";
            border-radius:" & raio_icone & ";
            background:" & cor_icone_fundo & ";
            color:" & cor_icone & ";
            display:flex;
            align-items:center;
            justify-content:center;
            flex:0 0 auto;
        '>" &
            "<svg viewBox='0 0 24 24' fill='none' stroke='" & cor_icone & "'
                stroke-width='2' stroke-linecap='round' stroke-linejoin='round'
                style='width:" & tamanho_icone_svg & "; height:" & tamanho_icone_svg & "; display:block;'>" &
                "<line x1='12' y1='1' x2='12' y2='23'></line>" &
                "<path d='M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6'></path>" &
            "</svg>" &
        "</div>",
        ""
    )


-- ──────────────────────────────────────────────────────────────────
-- 📐 ESPAÇAMENTOS INTERNOS
-- ──────────────────────────────────────────────────────────────────

VAR gap_header = ROUND(20 * FatorEscalaConteudo, 0) & "px"
VAR gap_badge = ROUND(18 * FatorEscalaConteudo, 0) & "px"

VAR margin_valor_top = ROUND(20 * FatorEscalaConteudo, 0) & "px"
VAR margin_badge_top = ROUND(24 * FatorEscalaConteudo, 0) & "px"


-- ╔══════════════════════════════════════════════════════════════════╗
-- ║                   ⚙️ LÓGICA DE NEGÓCIO                          ║
-- ╚══════════════════════════════════════════════════════════════════╝

VAR FaturamentoAtual = [$ Faturamento]
VAR FaturamentoMeta = [$ Meta]
VAR yoy = [% Faturamento YoY]
VAR atingimento_meta = [% Faturamento vs Meta]


VAR MetaAtingida =
    atingimento_meta >= 1

VAR cor_meta_status =
    IF(MetaAtingida, cor_positivo, cor_negativo)


VAR cor_yoy_status =
    IF(yoy >= 0, cor_positivo, cor_negativo)

VAR cor_badge_fundo =
    IF(yoy >= 0, cor_badge_fundo_positivo, cor_badge_fundo_negativo)

VAR icone_variacao =
    IF(yoy >= 0, "↗", "↘")


VAR FaltaMetaValor =
    MAX(0, FaturamentoMeta - FaturamentoAtual)

VAR FaturamentoAbsoluto =
    ABS(FaturamentoAtual)

VAR FaltaMetaAbsoluto =
    ABS(FaltaMetaValor)


VAR valor_formatado =
    SWITCH(
        TRUE(),
        FaturamentoAbsoluto >= 1000000000, "R$ " & FORMAT(FaturamentoAtual / 1000000000, "#,##0.0") & " B",
        FaturamentoAbsoluto >= 1000000,    "R$ " & FORMAT(FaturamentoAtual / 1000000,    "#,##0.0") & " M",
        FaturamentoAbsoluto >= 1000,       "R$ " & FORMAT(FaturamentoAtual / 1000,       "#,##0.0") & " K",
        "R$ " & FORMAT(FaturamentoAtual, "#,##0.00")
    )


VAR falta_meta_formatado =
    SWITCH(
        TRUE(),
        FaltaMetaAbsoluto >= 1000000000, "R$ " & FORMAT(FaltaMetaValor / 1000000000, "#,##0.0") & " B",
        FaltaMetaAbsoluto >= 1000000,    "R$ " & FORMAT(FaltaMetaValor / 1000000,    "#,##0.0") & " M",
        FaltaMetaAbsoluto >= 1000,       "R$ " & FORMAT(FaltaMetaValor / 1000,       "#,##0.0") & " K",
        "R$ " & FORMAT(FaltaMetaValor, "#,##0.00")
    )


VAR yoy_formatado =
    FORMAT(ABS(yoy), "0.0%")

VAR atingimento_formatado =
    FORMAT(atingimento_meta, "0%")


VAR qtd_preenchidas =
    ROUNDUP(
        MIN(1, MAX(0, atingimento_meta)) * qtd_bolinhas,
        0
    )

VAR waffle_html =
    CONCATENATEX(
        GENERATESERIES(1, qtd_bolinhas, 1),
        VAR indice_visual = [Value]
        VAR linha = INT((indice_visual - 1) / 5) + 1
        VAR coluna = MOD(indice_visual - 1, 5) + 1

        VAR indice_preenchimento = (5 - linha) * 5 + coluna

        VAR preenchido = indice_preenchimento <= qtd_preenchidas
        VAR cor_bolinha = IF(preenchido, cor_meta_status, cor_waffle_vazio)

        RETURN
            "<span style='
                width:" & tamanho_bolinha & ";
                height:" & tamanho_bolinha & ";
                border-radius:50%;
                background:" & cor_bolinha & ";
                display:block;
            '></span>",
        ""
    )


-- ╔══════════════════════════════════════════════════════════════════╗
-- ║                   🧱 MONTAGEM DO HTML                           ║
-- ╚══════════════════════════════════════════════════════════════════╝

RETURN
"
<div style='
    width:" & largura_card & ";
    height:" & altura_card & ";
    box-sizing:border-box;
    background:" & cor_fundo_card & ";
    border:1px solid " & cor_borda_card & ";
    border-radius:" & raio_borda & ";
    padding:" & padding_card & ";
    font-family:" & fonte_principal & ";
    box-shadow:" & sombra_card & ";
    display:flex;
    justify-content:space-between;
    align-items:center;
    overflow:hidden;
'>

    <div style='
        display:flex;
        flex-direction:column;
        justify-content:space-between;
        height:100%;
        min-width:0;
    '>

        <div style='display:flex; align-items:center; gap:" & gap_header & ";'>
            " & IconeSVG & "

            <div style='
                color:" & cor_titulo & ";
                font-family:" & fonte_titulo & ";
                font-size:" & tamanho_titulo & ";
                font-weight:" & peso_titulo & ";
                line-height:1;
                white-space:nowrap;
            '>
                " & titulo_card & "
            </div>
        </div>

        <div style='
            color:" & cor_valor & ";
            font-family:" & fonte_valor & ";
            font-size:" & tamanho_valor & ";
            font-weight:" & peso_valor & ";
            letter-spacing:" & espacamento_letra_valor & ";
            line-height:1;
            margin-top:" & margin_valor_top & ";
            white-space:nowrap;
        '>
            " & valor_formatado & "
        </div>

        <div style='
            display:flex;
            align-items:center;
            gap:" & gap_badge & ";
            margin-top:" & margin_badge_top & ";
            white-space:nowrap;
        '>
            <div style='
                background:" & cor_badge_fundo & ";
                color:" & cor_yoy_status & ";
                border-radius:" & raio_badge & ";
                padding:" & padding_badge_vertical & " " & padding_badge_horizontal & ";
                font-family:" & fonte_label_comparativo & ";
                font-size:" & tamanho_label_comparativo & ";
                font-weight:" & peso_label_comparativo & ";
                line-height:1;
                white-space:nowrap;
            '>
                " & icone_variacao & " " & yoy_formatado & "
            </div>

            <div style='
                color:" & cor_texto_secundario & ";
                font-family:" & fonte_label_comparativo & ";
                font-size:" & tamanho_label_comparativo & ";
                font-weight:" & peso_label_comparativo & ";
                white-space:nowrap;
            '>
                " & texto_comparativo & "
            </div>
        </div>

    </div>

    <div style='
        width:" & largura_bloco_meta & ";
        display:flex;
        flex-direction:column;
        align-items:center;
        justify-content:center;
        gap:" & gap_bolinha & ";
        white-space:nowrap;
        flex:0 0 auto;
    '>

        <div style='
            display:grid;
            grid-template-columns:repeat(5, " & tamanho_bolinha & ");
            grid-auto-rows:" & tamanho_bolinha & ";
            gap:" & gap_bolinha & ";
            justify-content:center;
            align-content:center;
        '>
            " & waffle_html & "
        </div>

        <div style='
            color:" & cor_meta_status & ";
            font-family:" & fonte_percentual_meta & ";
            font-size:" & tamanho_percentual_meta & ";
            font-weight:" & peso_percentual_meta & ";
            line-height:1;
            letter-spacing:-1.4px;
            white-space:nowrap;
        '>
            " & atingimento_formatado & "
        </div>

        <div style='
            color:" & cor_texto_secundario & ";
            font-family:" & fonte_label_meta & ";
            font-size:" & tamanho_label_meta & ";
            font-weight:" & peso_label_meta & ";
            line-height:1.15;
            text-align:center;
            white-space:nowrap;
        '>
            faltam <span style='color:" & cor_meta_status & ";'>" & falta_meta_formatado & "</span> da meta
        </div>

    </div>

</div>
"