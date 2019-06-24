# Concourse git namespace resource

A Concourse git namespace resource that returns all projects in a namespace and can optionally clone them in.

## Use
docker pull gbvanrenswoude/concourse-git-namespace-resource:latest
versions_tagged: 0.0.1

## Installing

Bake the docker image with docker build and store it somewhere concourse can access it.  
Add the resource type to your pipeline:

```yaml
resource_types:
- name: git-group
  type: docker-image
  source:
    repository: gbvanrenswoude/concourse-git-namespace-resource

resources:
- name: some-group
  type: git-group
  icon: fab
  source:
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
### Source Configuration
* `namespace`: *Required.* Specify namespace. (for example group name)
* `basepath`: *Required.* Specify base path of gitlab install
* `token`: *Required.* Specify GITLAB_PRIVATE_TOKEN.
* `searchparam`: *Optional.* Specify string to match projects to.

### Parameters
* `clone`: *Optional.* Defaults to false. Allowed values: `true` and `false`. Clones in all when set to `true`. Make sure you have permissions and access to do so.


----
## Behavior

### `check`: Check for a change in the project set. Version tracking is done by hashing the list of all projects.

### `in`: Fetches the projects in projects.json. Optionally clone all projects under their project name.

### `out`: Does nothing. (for now)



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
Make sure you have python3 and your dependencies installed if you run the code directly and not via the Docker image.

If you run the Docker image, comment in the ENV vars in the Dockerfile bc corporate. Run the docker image and pass the sample input to stdin
```
docker build -t bob .
docker run --rm -it -v ~/.aws:/root/.aws bob
```
When in bob
```
cd /opt/resource && cat ../test/sample_input_in.json | ./in './'
cd /opt/resource && cat ../test/sample_input_check.json | ./check './'
```
----
