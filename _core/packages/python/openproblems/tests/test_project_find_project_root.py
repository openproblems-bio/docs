import os
from openproblems.project import find_project_root

def test_find_project_root(tmpdir):
    # Create project directory and subdirectories
    proj_dir = os.path.join(tmpdir, 'project')
    os.makedirs(proj_dir, exist_ok=True)
    src_dir = os.path.join(proj_dir, 'src')
    os.makedirs(src_dir, exist_ok=True)

    # Create files
    proj_config = os.path.join(proj_dir, '_viash.yaml')
    open(proj_config, 'w').close()

    comp_config = os.path.join(src_dir, 'config.vsh.yaml')
    open(comp_config, 'w').close()

    comp_script = os.path.join(src_dir, 'script.R')
    open(comp_script, 'w').close()

    # Perform assertions
    assert find_project_root(comp_script) == proj_dir
    assert find_project_root(comp_config) == proj_dir
    assert find_project_root(proj_config) == proj_dir
    assert find_project_root(src_dir) == proj_dir
    assert find_project_root(proj_dir) == proj_dir
    assert find_project_root(tmpdir) is None
