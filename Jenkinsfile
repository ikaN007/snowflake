pipeline {
    options {
      timeout(time: 1, unit: 'HOURS') 
  }
    agent {
        node {
            label 'snowflake'
        }
    }
  stages {
    stage('Moving .snowsql to workspace and replacing snowsql in /bin') {
         steps {
           container('sqitch'){
	     sh '''
	     cp -r /root/bin/snowsql /bin/
	     cp -r ~/.snowsql ./
	     cp -r ~/.snowsql/config ./.snowsql/config
	     chmod -R 777 .
             ''' 
         }
       }
      }
    stage('Fetch the DDL from TEST_DEV DB') {
      	  when {
	      branch 'TEST_DEV'
	      }
	  steps {
	      container('sqitch'){
	           sh '''
	           cat Objectlist.txt
		   Objectname=`cat Ojectlist | awk '{print $1}'`
		   snowsql -q "SELECT GET_DDL('TABLE','$Objectname')" | sed -n '1!p'
		   snowsql -q "SELECT GET_DDL('TABLE','$Objectname')" | sed -n '1!p' > BIDW.DBA.$objectname
		   cat BIDW.DBA.$objectname
		   '''
		}
	}
     }
	  
  }
}
