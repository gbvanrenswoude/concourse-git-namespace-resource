# Concourse gitlab namespace/groups resource

A Concourse gitlab namespace/groups resource that returns all projects in a namespace and can optionally clone them in.
Supports 2 gitlab endpoints `projects` and `groups`.

## Use
docker pull gbvanrenswoude/concourse-gitlab-namespace-resource:latest
versions_tagged: 0.0.1

## Installing

Bake the docker image with docker build and store it somewhere concourse can access it.  
Add the resource type to your pipeline:

```yaml
resource_types:
- name: git-group
  type: docker-image
  source:
    repository: gbvanrenswoude/concourse-gitlab-namespace-resource:0.0.1

resources:
- name: some-group
  type: git-group
  icon: fab
  source:
    tag: any_project_tag
    namespace: groupname
    basepath: https://gitlab.com/
    token: ((secrettoken))
    searchparam: onlycoolprojects

jobs:
- name: do-something
  plan:
  - get: all-for-some-group
    trigger: true
```

----
## Behavior

### `check`:
Check for a change in the project set. Version tracking is done by hashing the list of all projects.

### `in`:
Fetches the projects and deliver them in json format in projects.json and lowercase name in projectlist.txt. Optionally clone in all projects under their project name.

### `out`:
Does nothing. (for now)

----
### Source Configuration
* `driver`: *Optional.* `groups` or `projects` supported. Defaults to projects. Specifies which gitlab api endpoint to use.
* `basepath`: *Required.* Specify base path of gitlab install
* `token`: *Required.* Specify GITLAB_PRIVATE_TOKEN.
* `searchparam`: *Optional.* Specify string to match projects to.

#### projects specific
* `namespace`: *Required.* Specify namespace. (for example group name)
* `tag`: *Optional.* Select only projects with this tag.

#### groups specific
* `groupname`: *Optional.* Specify groupname
* `include_subgroup_projects`: *Optional.* `true` or `false`. Defaults to `true`
* `subgroupname`: *Optional.* Specify subgroupname
* `fullquery`: *Optional.* Overrides both other params for the groups driver. Allows you to specify own extended groups api path to query out. Use when wanting projects from subgroups of subgroups e.d.


### Parameters
* `clone`: *Optional.* Defaults to false. Allowed values: `true` and `false`. Clones in all when set to `true`. Make sure you have permissions and access to do so ;)


-----
### How to run locally
To run the check or in commands locally, use:
```
cd assets
cat ../test/sample_input_in.json | ./in './'
cat ../test/sample_input_in.json | ./in './' 2> /dev/null
```
and check
```
cat ../test/sample_input_check.json | ./check
cat ../test/sample_input_check.json | ./check 2> /dev/null
```
and out
```
cat ../test/sample_input_out.json | ./check
cat ../test/sample_input_out.json | ./check 2> /dev/null
```

```
docker build -t bob .
docker run --rm -it -v ~/.aws:/root/.aws bob
```
When in bob
```
cd /opt/resource && cat ../test/sample_input_in_groups.json | ./in './'
cd /opt/resource && cat ../test/sample_input_check_groups.json | ./check './'
```
----


### TODOs
- handle exceptions better, especially around the namespace selection and curl
