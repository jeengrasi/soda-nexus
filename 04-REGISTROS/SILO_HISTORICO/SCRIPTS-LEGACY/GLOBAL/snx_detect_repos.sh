#!/usr/bin/env bash

echo "=== SODA-NEXUS :: DETECCIÓN AUTOMÁTICA DE REPOSITORIOS GIT ==="
echo ""

find ~ -type d -name ".git" 2>/dev/null | while read gitdir; do
    repo_dir=$(dirname "$gitdir")
    echo "Repositorio encontrado: $repo_dir"

    cd "$repo_dir" || continue

    remote=$(git remote get-url origin 2>/dev/null)
    echo "  → URL remota: $remote"

    if [ -d "$repo_dir/docs" ]; then
        echo "  → Tiene carpeta /docs/"
    else
        echo "  → NO tiene carpeta /docs/"
    fi

    if [ -d "$repo_dir/docs/monitor" ]; then
        echo "  → Tiene carpeta /docs/monitor/"
    else
        echo "  → NO tiene carpeta /docs/monitor/"
    fi

    echo ""
done

echo "=== FIN DE ESCANEO ==="
