import os
import re
import argparse
from packaging.version import Version

# Fonction de versionnement
def bump_version_global(out_dir):
    """Génère la nouvelle version pour les procédures."""
    os.makedirs(out_dir, exist_ok=True)
    pattern = re.compile(r"V(\d+\.\d+\.\d+)__.*\.sql$")
    versions = []
    
    # Cherche les fichiers de procédure et extrait la version la plus récente
    for fname in os.listdir(out_dir):
        if (m := pattern.match(fname)):
            versions.append(Version(m.group(1)))

    if versions:
        latest = max(versions)
        # Incrémente la version mineure si c'est le cas
        new = Version(f"{latest.major}.{latest.minor}.{latest.micro+1}")
    else:
        # Si aucune version n'existe, commence à V1.1.0
        new = Version("1.1.0")

    return f"V{new.public}"

# Fonction de génération de la procédure
def generate_procedure(layer):
    """Génère les procédures complètes pour la couche spécifiée."""
    # Définir le répertoire `merge_dir` en fonction de la couche (silver ou gold)
    base_dir = "schemachange/objects_statements/scripts"
    
    # Déterminer le répertoire de merge en fonction de la couche
    if layer == "silver":
        merge_dir = os.path.join(base_dir, "silver")
        proc_names = ["process_bronze_to_silver"]  # Liste des procédures Silver
    elif layer == "gold":
        merge_dir = os.path.join(base_dir, "gold")
        proc_names = ["process_silver_to_gold"]  # Liste des procédures Gold
    else:
        print("Layer spécifié invalide. Utilisez 'silver' ou 'gold'.")
        return
    
    # Vérifier que le répertoire existe
    if not os.path.exists(merge_dir):
        print(f"Le répertoire {merge_dir} n'existe pas.")
        return
    
    # Déduire le répertoire de sortie
    out_dir = "schemachange/objects_statements/procedures"

    # Pour chaque procédure dans la couche (silver ou gold), générer la procédure correspondante
    for proc_name in proc_names:
        # Créer le fichier de procédure avec versionnement
        version_tag = bump_version_global(out_dir)
        fname = f"{version_tag}__{proc_name}.sql"
        output_file = os.path.join(out_dir, fname)

        merged_body = ""
        for sql in sorted(os.listdir(merge_dir)):
            if sql.endswith(".sql"):
                path = os.path.join(merge_dir, sql)
                with open(path, "r", encoding="utf-8") as f:
                    merged_body += f"-- From: {sql}\n"
                    merged_body += f.read().rstrip() + "\n\n"

        #  (SILVER_LAYER ou GOLD_LAYER)
        HEADER = f"""CREATE OR REPLACE PROCEDURE {layer.upper()}_LAYER.{proc_name}()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
"""
        FOOTER = """
  RETURN '{proc_name} terminé';
END;
$$;
"""

        with open(output_file, "w", encoding="utf-8") as out:
            out.write(HEADER)
            out.write(merged_body)
            out.write(FOOTER.format(proc_name=proc_name))

        print(f"Generated {output_file}")

def main():
    """Lance la génération des procédures."""
    parser = argparse.ArgumentParser(description="Génère des procédures SQL pour différentes couches.")
    parser.add_argument('--layer', type=str, required=True, choices=['silver', 'gold'], help="Spécifie la couche (silver ou gold)")

    args = parser.parse_args()

    # Appel de la fonction avec les paramètres spécifiés
    generate_procedure(args.layer)

if __name__ == "__main__":
    main()
