#!/bin/nu

def fetch_version [
	--version-id: string
	--version-type: string
] {
	let version_manifest = (fetch https://launchermeta.mojang.com/mc/game/version_manifest.json)

	let version = ($version_manifest.versions | where id == $version-id | where type == $version-type | first 1)

	fetch $version.url
}

def fetch_jar [
	--download-type: string
	version_data
] {
	let jar_url = ($version_data.downloads | get $download-type | get url)
	fetch $jar_url 
}

def fetch_libraries [
	libraries
	output_dir
] {
	let-env output_dir = $output_dir

	$libraries | par-each { |lib|
		let path = (build-string $env.output_dir "/" $lib.name ".jar")
		echo (build-string "Downloading " $lib.name " to " $path)
		fetch $lib.url | save $path
	}
}

def extract_jars [] {
	cd ./work/classes
	for j in (ls ../libraries/**/*.jar) {
		jar -xvf $j.name
	}
	jar -xvf ../client.jar
	rm -rf META-INF
	cd ../../
}

let config = (open build.toml)

mkdir work work/libraries work/classes

echo $"(ansi blue)[fetching jars](ansi reset)"
let version = (fetch_version --version-id 1.19 --version-type release)
let libraries = (
	(
		$version.libraries | par-each { |it|
			[[name, url]; [$it.name, $it.downloads.artifact.url]]
		}
	) | append (
		$config.library | par-each { |it| 
			[[name, url]; [$it.name, (build-string $it.repo "/" $it.group "/" $it.name "/" $it.version "/" $it.name "-" $it.version ".jar")]]
		}
	)
)

fetch_jar $version --download-type client | save work/client.jar
fetch_jar $version --download-type client_mappings | save work/client.mappings
fetch_libraries $libraries work/libraries
echo $"(ansi blue)[extracting jars](ansi reset)"
extract_jars
echo $"(ansi blue)[done](ansi reset)"
echo "you can now apply patches using the provided patcher script"
