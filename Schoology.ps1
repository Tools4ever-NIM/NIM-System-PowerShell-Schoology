#
# Schoology.ps1 - Schoology
#
$Log_MaskableKeys = @(
    'Password',
    "proxy_password",
    'clientSecret'
)

$Global:UsersCacheTime = Get-Date
$Global:CoursesCacheTime = Get-Date
$Global:GroupsCacheTime = Get-Date
$Global:SectionsCacheTime = Get-Date
$Global:SchoolsCacheTime = Get-Date
$Global:GroupEnrollmentsCacheTime = Get-Date
$Global:Users = [System.Collections.ArrayList]@()
$Global:Courses = [System.Collections.ArrayList]@()
$Global:Groups = [System.Collections.ArrayList]@()
$Global:Schools = [System.Collections.ArrayList]@()
$Global:Sections = [System.Collections.ArrayList]@()
$Global:GroupEnrollments = [System.Collections.ArrayList]@()

$Properties = @{
    Schools = @(
        @{ name = 'id';           				    options = @('default','key')} 
        @{ name = 'title';           				    options = @('default')}    
        @{ name = 'address1';           			options = @('default')}
        @{ name = 'address2';           		        options = @('default')}
        @{ name = 'city';           			options = @('default')}
        @{ name = 'state';           			options = @('default')}
        @{ name = 'postal_code';           		options = @('default')}
        @{ name = 'country';           			options = @('default')}
        @{ name = 'website';           options = @('default')}
        @{ name = 'phone';       options = @('default')}
        @{ name = 'fax';           			options = @('default')}
        @{ name = 'building_code';           	options = @('default')}
    )
    Users = @(
        @{ name = 'uid';           				    options = @('default','key')}    
        @{ name = 'id';           				    options = @('default')}    
        @{ name = 'school_id';           			options = @('default')}
        @{ name = 'synced';           		        options = @('default')}
        @{ name = 'school_uid';           			options = @('default')}
        @{ name = 'name_title';           			options = @('default')}
        @{ name = 'name_title_show';           		options = @('default')}
        @{ name = 'name_first';           			options = @('default')}
        @{ name = 'name_first_preferred';           options = @('default')}
        @{ name = 'use_preferred_first_name';       options = @('default')}
        @{ name = 'name_middle';           			options = @('default')}
        @{ name = 'name_middle_show';           	options = @('default')}
        @{ name = 'name_last';           			options = @('default')}
        @{ name = 'name_display';           		options = @('default')}
        @{ name = 'username';           		    options = @('default')}
        @{ name = 'primary_email';           		options = @('default')}
        @{ name = 'picture_url';           			options = @('default')}
        @{ name = 'gender';           				options = @('default')}
        @{ name = 'position';           			options = @('default')}
        @{ name = 'grad_year';           			options = @('default')}
        @{ name = 'password';           			options = @('default')}
        @{ name = 'role_id';           				options = @('default')}
        @{ name = 'tz_offset';           			options = @('default')}
        @{ name = 'tz_name';           				options = @('default')}
        @{ name = 'parents';           				options = @('default')}
        @{ name = 'child_uids';           			options = @('default')}
        @{ name = 'language';           			options = @('default')}
        @{ name = 'additional_buildings';           options = @('default')}
        @{ name = 'parent_access_code';           	options = @('default')}
    )
    Groups = @(
        @{name ="id";                                   options = @('default','key')}
        @{name ="title";                                   options = @('default')}
        @{name ="description";                                   options = @('default')}
        @{name ="website";                                   options = @('default')}
        @{name ="access_code";                                   options = @('default')}
        @{name ="category";                                   options = @('default')}
        @{name ="group_code";                                   options = @('default')}
        @{name ="school_id";                                   options = @('default')}
        @{name ="building_id";                                   options = @('default')}
    )
    Courses =@(
        @{name ="id";                                   options = @('default','key')}
        @{name ="title";                                options = @('default')}
        @{name ="course_code";                          options = @('default')}
        @{name ="department";                           options = @('default')}
        @{name ="description";                          options = @('default')}
        @{name ="credits";                              options = @('default')}
        @{name ="subject_area";                         options = @('default')}
        @{name ="building_id";                          options = @('default')}
        @{name ="grade_level_range_start";              options = @('default')}
        @{name ="grade_level_range_end";                options = @('default')}

    )
    Sections = @(
        @{name ="id";                                   options = @('default','key')}
        @{ name = 'course_title';           				    options = @('default')}
        @{ name = 'course_code';           				    options = @('default')}
        @{ name = 'course_id';           				    options = @('default')}
        @{ name = 'school_id';           				    options = @('default')}
        @{ name = 'access_code';           				    options = @('default')}
        @{ name = 'section_title';           				    options = @('default')}
        @{ name = 'section_code';           				    options = @('default')}
        @{ name = 'section_school_code';           				    options = @('default')}
        @{ name = 'active';           				    options = @('default')}
        @{ name = 'description';           				    options = @('default')}
        @{ name = 'location';           				    options = @('default')}
        @{ name = 'meeting_days';           				    options = @('default')}
        @{ name = 'start_time';           				    options = @('default')}
        @{ name = 'end_time';           				    options = @('default')}
        @{ name = 'weight';           				    options = @('default')}
        @{ name = 'admin';           				    options = @('default')}


    )
    GroupEnrollments = @(
        @{name ="id";                                   options = @('default','key')}
        @{ name = 'uid';           				    options = @('default')}
        @{ name = 'school_uid';           				    options = @('default')}
        @{ name = 'name_title';           				    options = @('default')}
        @{ name = 'name_first';           				    options = @('default')}
        @{ name = 'name_first_preferred';           				    options = @('default')}
        @{ name = 'name_middle';           				    options = @('default')}
        @{ name = 'name_last';           				    options = @('default')}
        @{ name = 'name_display';           				    options = @('default')}
        @{ name = 'status';           				    options = @('default')}
    )

}

#
# System functions
#
function Idm-SystemInfo {
    param (
        # Operations
        [switch] $Connection,
        [switch] $TestConnection,
        [switch] $Configuration,
        # Parameters
        [string] $ConnectionParams
    )

    Log info "-Connection=$Connection -TestConnection=$TestConnection -Configuration=$Configuration -ConnectionParams='$ConnectionParams'"

    if ($Connection) {
        @(
            @{
                name = 'clientKey'
                type = 'textbox'
                label = 'Client Key'
                label_indent = $true
                tooltip = 'Client API Key'
                value = ''
            }
            @{
                name = 'clientSecret'
                type = 'textbox'
                password = $true
                label = 'Client Secret'
                label_indent = $true
                tooltip = 'Client API Secret'
                value = ''
            }
            @{
                name = 'use_proxy'
                type = 'checkbox'
                label = 'Use Proxy'
                description = 'Use Proxy server for requests'
                value = $false # Default value of checkbox item
            }
            @{
                name = 'proxy_address'
                type = 'textbox'
                label = 'Proxy Address'
                description = 'Address of the proxy server'
                value = 'http://127.0.0.1:8888'
                disabled = '!use_proxy'
                hidden = '!use_proxy'
            }
            @{
                name = 'use_proxy_credentials'
                type = 'checkbox'
                label = 'Use Proxy Credentials'
                description = 'Use credentials for proxy'
                value = $false
                disabled = '!use_proxy'
                hidden = '!use_proxy'
            }
            @{
                name = 'proxy_username'
                type = 'textbox'
                label = 'Proxy Username'
                label_indent = $true
                description = 'Username account'
                value = ''
                disabled = '!use_proxy_credentials'
                hidden = '!use_proxy_credentials'
            }
            @{
                name = 'proxy_password'
                type = 'textbox'
                password = $true
                label = 'Proxy Password'
                label_indent = $true
                description = 'User account password'
                value = ''
                disabled = '!use_proxy_credentials'
                hidden = '!use_proxy_credentials'
            }
            @{
                name = 'nr_of_retries'
                type = 'textbox'
                label = 'Max. number of retry attempts'
                description = ''
                value = 5
            }
            @{
                name = 'retryDelay'
                type = 'textbox'
                label = 'Seconds to wait for retry'
                description = ''
                value = 2
            }
            @{
                name = 'nr_of_sessions'
                type = 'textbox'
                label = 'Max. number of simultaneous sessions'
                description = ''
                value = 1
            }
            @{
                name = 'sessions_idle_timeout'
                type = 'textbox'
                label = 'Session cleanup idle time (minutes)'
                description = ''
                value = 1
            }
        )
    }

    if ($TestConnection) {
        
    }

    if ($Configuration) {
        @()
    }

    Log info "Done"
}

function Idm-OnUnload {
}

#
# Object CRUD functions
#


<#
Note: Testing currently and this only seems to pull in the initial school and not all schools. 
#>
function Idm-SchoolsRead {
    param (
        # Mode
        [switch] $GetMeta,    
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams

    )
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams
        $Class = 'Schools'
        
        if ($GetMeta) {
            Get-ClassMetaData -SystemParams $SystemParams -Class $Class
            
        } else {

            if(     $Global:Schools.count -lt 1 `
                    -or ( ((Get-Date) - $Global:SchoolsCacheTime) -gt (new-timespan -minutes 5) ) 
            ) {   

                $uri = "v1/schools"
                
                $splat = @{
                    SystemParams = $system_params
                    Method = "GET"
                    Uri = $uri                    
                    Body = $null
                    ResponseProperty = 'schools'
                }

                $Global:Schools.Add(@() + (Execute-SchoologyRequest @splat).school )
                $Global:SchoolsCacheTime = Get-Date
            }
            
            $properties = ($Global:Properties.$Class).name
                $hash_table = [ordered]@{}

                foreach ($prop in $properties.GetEnumerator()) {
                    $hash_table[$prop] = ""
                }

                foreach($rowItem in $Global:Schools) {
                    $row = New-Object -TypeName PSObject -Property $hash_table

                    foreach($prop in $rowItem.PSObject.properties) {
                        if(!$properties.contains($prop.Name)) { continue }
                        $row.($prop.Name) = $prop.Value
                    }

                    $row
                }
            
        }
}

function Idm-UsersRead {
    param (
        # Mode
        [switch] $GetMeta,    
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams

    )
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams
        $Class = 'Users'
        
        if ($GetMeta) {
            Get-ClassMetaData -SystemParams $SystemParams -Class $Class
            
        } else {

            if(     $Global:Users.count -lt 1 `
                    -or ( ((Get-Date) - $Global:UsersCacheTime) -gt (new-timespan -minutes 5) ) 
            ) {   

                $uri = "v1/users?parent_access_codes=1"
                
                $splat = @{
                    SystemParams = $system_params
                    Method = "GET"
                    Uri = $uri                    
                    Body = $null
                    ResponseProperty = 'user'
                }

                $Global:Users.AddRange(@() + (Execute-SchoologyRequest @splat) )
                $Global:UsersCacheTime = Get-Date
            }
            
            $properties = ($Global:Properties.$Class).name
                $hash_table = [ordered]@{}

                foreach ($prop in $properties.GetEnumerator()) {
                    $hash_table[$prop] = ""
                }

                foreach($rowItem in $Global:Users) {
                    $row = New-Object -TypeName PSObject -Property $hash_table

                    foreach($prop in $rowItem.PSObject.properties) {
                        if(!$properties.contains($prop.Name)) { continue }
                        $row.($prop.Name) = $prop.Value
                    }

                    $row
                }
            
        }
}

function Idm-GroupsRead {
    param (
        # Mode
        [switch] $GetMeta,    
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams

    )
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams
        $Class = 'Groups'
        
        if ($GetMeta) {
            Get-ClassMetaData -SystemParams $SystemParams -Class $Class
            
        } else {

            if(     $Global:Groups.count -lt 1 `
                    -or ( ((Get-Date) - $Global:GroupsCacheTime) -gt (new-timespan -minutes 5) ) 
            ) {   

                $uri = "v1/groups"
                
                $splat = @{
                    SystemParams = $system_params
                    Method = "GET"
                    Uri = $uri                    
                    Body = $null
                    ResponseProperty = 'group'
                }

                $Global:Groups.AddRange(@() + (Execute-SchoologyRequest @splat) )
                $Global:GroupsCacheTime = Get-Date
            }
            
            $properties = ($Global:Properties.$Class).name
                $hash_table = [ordered]@{}

                foreach ($prop in $properties.GetEnumerator()) {
                    $hash_table[$prop] = ""
                }

                foreach($rowItem in $Global:Users) {
                    $row = New-Object -TypeName PSObject -Property $hash_table

                    foreach($prop in $rowItem.PSObject.properties) {
                        if(!$properties.contains($prop.Name)) { continue }
                        $row.($prop.Name) = $prop.Value
                    }

                    $row
                }
            
        }
}

function Idm-CoursesRead {
    param (
        # Mode
        [switch] $GetMeta,    
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams

    )
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams
        $Class = 'Courses'
        
        if ($GetMeta) {
            Get-ClassMetaData -SystemParams $SystemParams -Class $Class
            
        } else {

            if(     $Global:Courses.count -lt 1 `
                    -or ( ((Get-Date) - $Global:CoursesCacheTime) -gt (new-timespan -minutes 5) ) 
            ) {   

                $uri = "v1/courses"
                
                $splat = @{
                    SystemParams = $system_params
                    Method = "GET"
                    Uri = $uri                    
                    Body = $null
                    ResponseProperty = 'course'
                }

                $Global:Courses.AddRange(@() + (Execute-SchoologyRequest @splat) )
                $Global:CoursesCacheTime = Get-Date
            }
            
            $properties = ($Global:Properties.$Class).name
                $hash_table = [ordered]@{}

                foreach ($prop in $properties.GetEnumerator()) {
                    $hash_table[$prop] = ""
                }

                foreach($rowItem in $Global:Courses) {
                    $row = New-Object -TypeName PSObject -Property $hash_table

                    foreach($prop in $rowItem.PSObject.properties) {
                        if(!$properties.contains($prop.Name)) { continue }
                        $row.($prop.Name) = $prop.Value
                    }

                    $row
                }
            
        }
}

function Idm-SectionsRead {
    param (
        # Mode
        [switch] $GetMeta,    
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams

    )
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams
        $Class = 'Sections'
        
        if ($GetMeta) {
            Get-ClassMetaData -SystemParams $SystemParams -Class $Class
            
        } else {

            if(     $Global:Courses.count -gt 1 `
                    -or ( ((Get-Date) - $Global:SectionsCacheTime) -gt (new-timespan -minutes 5) ) 
            ) {   

                foreach($Course in $Global:Courses){
                    $uri = ("v1/courses/{0}/sections" -f $course.id)
                
                    $splat = @{
                        SystemParams = $system_params
                        Method = "GET"
                        Uri = $uri                    
                        Body = $null
                        ResponseProperty = 'section'
                    }
                    $Global:Sections.Add((Execute-SchoologyRequest @splat))
                


                }
                $Global:SectionsCacheTime = Get-Date
            }
            
            $properties = ($Global:Properties.$Class).name
                $hash_table = [ordered]@{}

                foreach ($prop in $properties.GetEnumerator()) {
                    $hash_table[$prop] = ""
                }

                foreach($rowItem in $Global:Sections) {
                    $row = New-Object -TypeName PSObject -Property $hash_table

                    foreach($prop in $rowItem.PSObject.properties) {
                        if(!$properties.contains($prop.Name)) { continue }
                        $row.($prop.Name) = $prop.Value
                    }

                    $row
                }
            
        }
}

function Idm-GroupEnrollmentsRead {
    param (
        # Mode
        [switch] $GetMeta,    
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams

    )
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams
        $Class = 'GroupEnrollments'
        
        if ($GetMeta) {
            Get-ClassMetaData -SystemParams $SystemParams -Class $Class
            
        } else {

            if(     $Global:Groups.count -gt 0 `
                    -or ( ((Get-Date) - $Global:GroupEnrollmentsCacheTime) -gt (new-timespan -minutes 5) ) 
            ) {   

                foreach($Group in $Global:Groups){
                    $uri = ("v1/groups/{0}/enrollments" -f $Group.id)
                
                    $splat = @{
                        SystemParams = $system_params
                        Method = "GET"
                        Uri = $uri                    
                        Body = $null
                        ResponseProperty = 'groupenrollments'
                    }
                    break
                    $test = (Execute-SchoologyRequest @splat)
                    Write-Host $test
                    $Global:GroupEnrollments.AddRange(@() + (Execute-SchoologyRequest @splat) )
                     


                }
                $Global:GroupEnrollmentsCacheTime = Get-Date
            }
            
            $properties = ($Global:Properties.$Class).name
                $hash_table = [ordered]@{}

                foreach ($prop in $properties.GetEnumerator()) {
                    $hash_table[$prop] = ""
                }

                foreach($rowItem in $Global:GroupEnrollments) {
                    $row = New-Object -TypeName PSObject -Property $hash_table

                    foreach($prop in $rowItem.PSObject.properties) {
                        if(!$properties.contains($prop.Name)) { continue }
                        $row.($prop.Name) = $prop.Value
                    }

                    $row
                }
            
        }
}


#
#   Internal Functions
#
function Get-SchoologyAuthorization {
    param (
        [hashtable] $SystemParams
    )
        $Authorization = (`
    'OAuth realm="Schoology API",' +
    'oauth_consumer_key="{0}",' +
    'oauth_token="",' +
    'oauth_nonce="{1}",' +
    'oauth_timestamp="{2}",' +
    'oauth_signature_method="PLAINTEXT",' +
    'oauth_version="1.0",' +
    'oauth_signature="{3}&"') `
        -f  $SystemParams.clientKey,
            ((New-Guid).Guid -replace '-'),
            [int64](Get-Date(Get-Date).ToUniversalTime() -UFormat %s),
            $SystemParams.clientSecret

    return $Authorization   

}

function Execute-SchoologyRequest {
    param (
        [hashtable] $SystemParams,
        [string] $Method,
        [string] $Body,
        [string] $Uri,
        [string] $ResponseProperty
    )

    $splat = @{
        Headers = @{
            "Authorization" = Get-SchoologyAuthorization $SystemParams
            "Accept" = "application/json"
            "Content-Type" = "application/json"
        }
        Method = $Method
        Uri = "https://api.schoology.com/$($Uri)"
    }

    if($Method -ne "GET") {
        $splat["Body"] = $Body
    } else {
        $splat["Body"] = @{
            page = 1
            limit = 50
        }
    }

     if($SystemParams.use_proxy)
                {
                    Add-Type @"
using System.Net;
using System.Security.Cryptography.X509Certificates;
public class TrustAllCertsPolicy : ICertificatePolicy {
    public bool CheckValidationResult(
        ServicePoint srvPoint, X509Certificate certificate,
        WebRequest request, int certificateProblem) {
        return true;
    }
}
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
                    
        $splat["Proxy"] = $SystemParams.proxy_address

        if($SystemParams.use_proxy_credentials)
        {
            $splat["proxyCredential"] = New-Object System.Management.Automation.PSCredential ($SystemParams.proxy_username, (ConvertTo-SecureString $SystemParams.proxy_password -AsPlainText -Force) )
        }
    }

    $responseData = [System.Collections.ArrayList]@()
    $attempt = 0
    $retryDelay = $SystemParams.retryDelay
    do {
        try {
                do{    
                    $attemptSuffix = if ($attempt -gt 0) { " (Attempt $($attempt + 1))" } else { "" }

                    if ($Method -eq "GET" -and $splat["Body"]) {
                        $queryParams = ($splat["Body"].GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join "&"
                        Log verbose "$($splat.Method) Call: $($splat.Uri)?$queryParams$attemptSuffix"
                    }
                    else {
                        Log verbose "$($splat.Method) Call: $($splat.Uri)$attemptSuffix"
                    }
                    
                    $splat.Headers = @{
                            "Authorization" = Get-SchoologyAuthorization $SystemParams
                            "Accept" = "application/json"
                            "Content-Type" = "application/json"
                    }

                    $response = Invoke-RestMethod @splat -ErrorAction Stop
                    $responseData.AddRange(@() + $response.$ResponseProperty)

                    if($null -eq $response.links.next -or $response.links.next.length -lt 1){
                        break
                    }
                    else{
                            $splat.Uri = $response.links.next
                            $splat.Body = $null 
                    }
                }while($true)
                

        } catch {
                $statusCode = $_.Exception.Response.StatusCode.value__
                if ($statusCode -eq 429 -or $statusCode -eq 401 -or $statusCode -eq 500) {
                    $attempt++
                    if ($attempt -ge $SystemParams.nr_of_retries) {
                        throw "Max retry attempts reached for $Uri"
                    }
                    Log warning "Received $statusCode. Retrying in $retryDelay seconds..."
                    Start-Sleep -Seconds $retryDelay
                    $retryDelay *= 2  # Exponential backoff
                } else {
                    throw  # Rethrow for other errors
                }
        }
        break
    } while ($true)

    return $responseData
}

function Get-ClassMetaData {
    param (
        [string] $SystemParams,
        [string] $Class
    )

    @(
        @{
            name = 'properties'
            type = 'grid'
            label = 'Properties'
            table = @{
                rows = @( $Global:Properties.$Class | ForEach-Object {
                    @{
                        name = $_.name
                        usage_hint = @( @(
                            foreach ($opt in $_.options) {
                                if ($opt -notin @('default', 'idm', 'key')) { continue }

                                if ($opt -eq 'idm') {
                                    $opt.Toupper()
                                }
                                else {
                                    $opt.Substring(0,1).Toupper() + $opt.Substring(1)
                                }
                            }
                        ) | Sort-Object) -join ' | '
                    }
                })
                settings_grid = @{
                    selection = 'multiple'
                    key_column = 'name'
                    checkbox = $true
                    filter = $true
                    columns = @(
                        @{
                            name = 'name'
                            display_name = 'Name'
                        }
                        @{
                            name = 'usage_hint'
                            display_name = 'Usage hint'
                        }
                    )
                }
            }
            value = ($Global:Properties.$Class | Where-Object { $_.options.Contains('default') }).name
        }
    )
}
