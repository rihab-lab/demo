"""
import os
import re
from packaging.version import Version

# Configuration des dossiers et noms de procédure
configs = [
    {
        "merge_dir": "schemachange/objects_statements/scripts/silver",
        "proc_name": "SILVER_LAYER.process_bronze_to_silver",
        "out_dir":  "schemachange/objects_statements/procedures"
    },
    {
        "merge_dir": "schemachange/objects_statements/scripts/gold",
        "proc_name": "GOLD_LAYER.process_silver_to_gold",
        "out_dir":  "schemachange/objects_statements/procedures"
    }
]


# Modèle de procédure
HEADER = CREATE OR REPLACE PROCEDURE {proc_name}()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN

FOOTER = 
  RETURN '{proc_name} terminé';
END;
$$;
"

def bump_version_global(out_dir):
    
    Parcourt tous les fichiers Vx.y.z__*.sql dans out_dir,
    retourne la nouvelle étiquette de version Vx.y.z (patch bump).
    
    os.makedirs(out_dir, exist_ok=True)

    pattern = re.compile(r"V(\d+\.\d+\.\d+)__.*\.sql$")
    versions = []
    for fname in os.listdir(out_dir):
        if (m := pattern.match(fname)):
            versions.append(Version(m.group(1)))

    if versions:
        latest = max(versions)
        new = Version(f"{latest.major}.{latest.minor}.{latest.micro+1}")
    else:
        new = Version("1.1.0")

    return f"V{new.public}"

def generate_procedure(merge_dir, proc_name, out_dir):
    # 1) bump global
    version_tag = bump_version_global(out_dir)
    fname = f"{version_tag}__{proc_name}.sql"
    output_file = os.path.join(out_dir, fname)

    # 2) concatène tous les SQL
    merged_body = ""
    for sql in sorted(os.listdir(merge_dir)):
        if sql.endswith(".sql"):
            path = os.path.join(merge_dir, sql)
            with open(path, "r", encoding="utf-8") as f:
                merged_body += f"-- From: {sql}\n"
                merged_body += f.read().rstrip() + "\n\n"

    # 3) écrit la procédure complète
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
"""