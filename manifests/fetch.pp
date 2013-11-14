#
# TODO implement function to extract from $title
# the artifact_id, group_id, and version
# - towards simplicity, this will allow the user
# to omit these three parameters
define nexus::fetch(
  $artifact_id = undef,
  $group_id    = undef,
  $version     = 'LATEST',
  $nexus_url   = 'http://repository.sonatype.org',
  $repository  = 'release',
  $deploy_at   = '/tmp',
  $timeout     = 0,
  $username    = undef,
  $password    = undef,
) {
  if (empty($artifact_id)) { fail('missing :artifact_id parameter') }
  if (empty($group_id)) { fail('missing :group_id parameter') }

  # TODO create function to build API endpoint
  $api_path = '/service/local/artifact/maven/redirect'
  $query = "?r=${repository}&g=${group_id}&a=${artifact_id}&v=${version}"
  $artifact_url = "${nexus_url}${api_path}${query}"

  if (empty($username) or empty($password)) {
    wget::fetch { "fetch ${title}":
      source      => $artifact_url,
      destination => $deploy_at,
      timeout     => $timeout,
    }
  } else {
    wget::authfetch { "fetch ${title}":
      source      => $artifact_url,
      destination => $deploy_at,
      timeout     => $timeout,
      user        => $username,
      password    => $password,
    }
  }
}
