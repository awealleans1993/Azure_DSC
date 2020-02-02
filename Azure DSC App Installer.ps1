Configuration ConfigName #Replace ConfigName with name of overall configuration as more than 1 application maybe installed

{    
    $PackageLocalPath = "C:\Temp\Setup.exe" #Destination the setup file will download to and execute from

    Import-DscResource -ModuleName xPSDesiredStateConfiguration #Ensure PSDesiredStateConfiguration module is imported in to Azure automation account
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node NodeName { #Replace NodeName with name of your Node, could be application name
    
	    Service ServiceName #Replace Service Name with name of application
	    {
		    Name = "Windows Service Name"
		    State = "Running"
		    DependsOn = "[Package]App" #Name of your package
	    }

	    xRemoteFile PackageFile { #Replace PackageFile application/file name
		    Uri = "URL to Setup File"
		    DestinationPath = $PackageLocalPath
	    }

	    Package App { #Replace App with name of Application
		    Ensure = "Present"
		    Path  = $PackageLocalPath
		    Name = "Product Name" #Ensure this matches the ProductName, extract MSI from EXE and use Orca to find this
		    ProductId = '' 
		    Arguments = '/S' #Application install argument for silent install or specifying config paramters
		    DependsOn = "[xRemoteFile]PackageFile" #Install depends on file previously being downloaded
	    }
    }
}