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
	     cat ~/.snowsql/config
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
		   pwd
		   ls -lrth
	           cat Objectlist.txt
		   Objectname=`cat Objectlist.txt | awk '{print $1}'`
		   snowsql -q "SELECT GET_DDL('TABLE','GDW_AUDIT.TEST_TABLE1')" | sed -n '1!p'
		   snowsql -q "SELECT GET_DDL('TABLE','$Objectname')" | sed -n '1!p' > BIDW.DBA.$Objectname
		   cat BIDW.DBA.$Objectname
		   '''
		}
	}
     }
    stage ('Email for Review') {
	    steps {
	    emailext body: 'Review the below Code', subject: 'Email For Review', to: 'yatin.sawant@officedepot.com'
	    }
    }
    stage ('Approve') {
	    steps {
		    input 'Approve the DDL to Deploy to QA'
		  }
	    {
		    sh '''
		    git clone https://github.com/devopsyatin/snowflake.git
		    cd snowflake
		    cp ../BIDW.DBA.$Objectname BIDW.DBA.$Objectname
		    git add .
		    git commit -m "adding the reviewed file"
		    git push -u origin QA
		    '''
	    }
    }
	  
  }
}
