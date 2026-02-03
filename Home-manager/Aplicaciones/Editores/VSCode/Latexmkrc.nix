# Home-manager/Aplicaciones/Editores/VSCode/latexmkrc.nix
#
# Configuración global de latexmk optimizada para documentos extensos.
# Se instala en ~/.latexmkrc
{ ... }:
{
  home.file.".latexmkrc".text = ''
    # ═══════════════════════════════════════════════════════════════════════════
    # LATEXMKRC - Configuración global para documentos LaTeX
    # ═══════════════════════════════════════════════════════════════════════════
    # Optimizado para libros matemáticos extensos (~1000 páginas)
    
    # ─────────────────────────────────────────────────────────────────────────────
    # Motor de compilación predeterminado: LuaLaTeX
    # ─────────────────────────────────────────────────────────────────────────────
    # LuaLaTeX ofrece:
    # - Soporte Unicode nativo
    # - Acceso a fuentes del sistema (fontspec)
    # - Mejor manejo de memoria para documentos grandes
    # - unicode-math para matemáticas modernas
    $pdf_mode = 4;  # 4 = lualatex
    
    # Comando lualatex con opciones optimizadas
    $lualatex = 'lualatex -synctex=1 -interaction=nonstopmode -file-line-error -shell-escape %O %S';
    
    # Alternativa: pdflatex (descomentar si se prefiere)
    # $pdf_mode = 1;
    # $pdflatex = 'pdflatex -synctex=1 -interaction=nonstopmode -file-line-error %O %S';
    
    # ─────────────────────────────────────────────────────────────────────────
    # Bibliografía: BibTeX (para natbib)
    # ─────────────────────────────────────────────────────────────────────────
    $bibtex = 'bibtex %O %S';
    $bibtex_use = 1;  # 1 = usar bibtex tradicional (natbib), 2 = biber (biblatex)
    
    # ─────────────────────────────────────────────────────────────────────────────
    # Índices y glosarios
    # ─────────────────────────────────────────────────────────────────────────────
    # makeindex para índices estándar
    $makeindex = 'makeindex %O -o %D %S';
    
    # Glosarios (glossaries-extra)
    add_cus_dep('glo', 'gls', 0, 'run_makeglossaries');
    add_cus_dep('acn', 'acr', 0, 'run_makeglossaries');
    sub run_makeglossaries {
        my ($base_name, $path) = fileparse( $_[0] );
        my @args = ( "-q", "-d", $path, $base_name );
        if ($silent) { unshift @args, "-q"; }
        return system "makeglossaries", @args;
    }
    push @generated_exts, 'glo', 'gls', 'glg';
    push @generated_exts, 'acn', 'acr', 'alg';
    $clean_ext .= ' %R.ist %R.xdy';
    
    # ─────────────────────────────────────────────────────────────────────────────
    # Limpieza de archivos auxiliares
    # ─────────────────────────────────────────────────────────────────────────────
    $clean_ext = 'synctex.gz synctex.gz(busy) run.xml tex.bak bbl bcf fdb_latexmk run tdo %R-blx.bib';
    
    # Archivos que no se eliminan con -c pero sí con -C
    @generated_exts = qw(aux idx ind lo* out toc acn acr alg bbl bcf blg brf fdb_latexmk glg glo gls ilg ist lof lot nav out snm synctex.gz synctex.gz(busy) tdo toc vrb xdy run.xml);
    
    # ─────────────────────────────────────────────────────────────────────────────
    # Comportamiento de compilación
    # ─────────────────────────────────────────────────────────────────────────────
    # Máximo de compilaciones (para resolver referencias cruzadas)
    $max_repeat = 7;
    
    # Mostrar errores de forma más clara
    $recorder = 1;
    
    # No detener en errores, continuar para mostrar todos
    $force_mode = 0;
    
    # ─────────────────────────────────────────────────────────────────────────────
    # Visor de PDF
    # ─────────────────────────────────────────────────────────────────────────────
    # Zathura como visor predeterminado
    $pdf_previewer = 'zathura %O %S';
    
    # Actualización automática del visor
    $pdf_update_method = 2;  # Señal para actualizar
    
    # ─────────────────────────────────────────────────────────────────────────────
    # Directorio de salida (opcional)
    # ─────────────────────────────────────────────────────────────────────────────
    # Descomentar para mantener archivos auxiliares separados:
    # $out_dir = 'build';
    # $aux_dir = 'build';
    
    # ─────────────────────────────────────────────────────────────────────────────
    # Optimizaciones para documentos grandes
    # ─────────────────────────────────────────────────────────────────────────────
    # Caché de formato para compilaciones más rápidas (requiere primera compilación larga)
    # $pre_tex_code = '\input{prelude}';
    
    # Paralelización de makeindex (si hay múltiples índices)
    # $do_cd = 1;
  '';
}
