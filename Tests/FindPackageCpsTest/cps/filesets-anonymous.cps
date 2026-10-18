{
  "cps_version": "0.15.0",
  "name": "FileSets-Anonymous",
  "cps_path": "@prefix@/cps",
  "components": {
    "Target": {
      "file_sets":
      [
        {
          "type": "includes",
          "root": "@prefix@/include",
          "files": [ "header1.h", "header2.h" ]
        },
        {
          "type": "includes",
          "root": "@prefix@/include",
          "files": [ "header3.h" ]
        }
      ],
      "type": "interface"
    }
  }
}
