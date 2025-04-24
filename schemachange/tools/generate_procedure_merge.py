import os
import re
from packaging.version import Version

# Configuration des dossiers et noms de procédure
configs = [
    {
        "merge_dir": "scripts/silver",
        "proc_name": "process_bronze_to_silver",
        "out_dir": "objects_statements/procedures"
    },
    {
        "merge_dir": "scripts/gold",
        "proc_name": "process_silver_to_gold",
        "out_dir": "objects_statements/procedures"
    }
]

# Modèle de procédure générer 
HEADER = """CREATE OR REPLACE PROCEDURE {proc_name}()
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

def bump_version(proc_name, out_dir):
    """
    Cherche tous les fichiers Vx.y.z__proc_name.sql dans out_dir,
    renvoie le nom bumpé en patch.
    """
    pattern = re.compile(r"V(\d+\.\d+\.\d+)__" + re.escape(proc_name) + r"\.sql$")
    versions = []
    for fname in os.listdir(out_dir):
        m = pattern.match(fname)
        if m:
            versions.append(Version(m.group(1)))
    if versions:
        latest = max(versions)
        new = Version(f"{latest.major}.{latest.minor}.{latest.micro+1}")
    else:
        # Démarre à 1.0.0 si aucune version existante
        new = Version("1.0.0")
    return f"V{new.public}__{proc_name}.sql"

def generate_procedure(merge_dir, proc_name, out_dir):
    # Détermine le nom de fichier bumpé
    fname = bump_version(proc_name, out_dir)
    output_file = os.path.join(out_dir, fname)

    # Concatène tous les .sql dans merge_dir
    merged_body = ""
    for sql in sorted(os.listdir(merge_dir)):
        if sql.endswith(".sql"):
            with open(os.path.join(merge_dir, sql), "r", encoding="utf-8") as f:
                merged_body += f"-- From: {sql}\n"
                merged_body += f.read().rstrip() + "\n\n"

    # Écrit la procédure complète
    os.makedirs(out_dir, exist_ok=True)
    with open(output_file, "w", encoding="utf-8") as out:
        out.write(HEADER.format(proc_name=proc_name))
        out.write(merged_body)
        out.write(FOOTER.format(proc_name=proc_name))

    print(f"✅ Generated {output_file}")

def main():
    for cfg in configs:
        generate_procedure(
            merge_dir=cfg["merge_dir"],
            proc_name=cfg["proc_name"],
            out_dir=cfg["out_dir"],
        )

if __name__ == "__main__":
    main()
