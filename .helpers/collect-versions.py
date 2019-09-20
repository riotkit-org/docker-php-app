#!/usr/bin/env python3

import os
import json


class CollectVersions:
    STANDARD_ARCH = 'x86_64'

    def main(self):
        architectures = self.collect_architectures()
        params = []

        for architecture in architectures:
            versions = self.collect_versions(architecture)

            for version in versions:
                params.append({
                    'version': version,
                    'arch': architecture,
                    'qemu': architecture != self.STANDARD_ARCH
                })

        return json.dumps(params)

    @staticmethod
    def collect_architectures() -> list:
        return list(map(
            lambda dir_entry: dir_entry.name,
            os.scandir('./dockerfile/src/versions')
        ))

    @staticmethod
    def collect_versions(architecture: str) -> list:
        return list(map(
            lambda dir_entry: dir_entry.name,
            os.scandir('./dockerfile/src/versions/%s' % architecture)
        ))


if __name__ == '__main__':
    print(CollectVersions().main())
