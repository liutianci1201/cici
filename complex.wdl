workflow complexWorkFlow {
    Array[String] contents
    
    scatter (content in contents) {
        call appendTask {
	   input:in = content
	}
    }

    call joinTask {
      input:in = appendTask.ouput_file
    }
   
    output {
        File outputs = joinTask.joinFile
    }
}



task appendTask {
    String in
    command {
      echo ${in} > "output.txt"
    }
    output {
      File ouput_file = "output.txt"
    }

    runtime {
      workerPath: "oss://geneapps-workspace/cromwell/worker.tar.gz"
      cluster: "OnDemand ecs.sn1.medium img-ubuntu-vpc"
      systemDisk: "cloud 40"
      dockerTag: "localhost:5000/cnv:latest oss://oceancloud-base-store/dockers/"
    }
}


task joinTask {
    Array[File] in

    command {
      cat ${sep=" && cat " in} >> "joined.txt"
    }

    output {
      File joinFile = "joined.txt"
    }

    runtime {
      workerPath: "oss://geneapps-workspace/cromwell/worker.tar.gz"
      cluster: "OnDemand ecs.sn1.medium img-ubuntu-vpc"
      systemDisk: "cloud 40"
      dockerTag: "localhost:5000/cnv:latest oss://oceancloud-base-store/dockers/"
    }
}
