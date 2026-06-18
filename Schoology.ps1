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
$Global:Users = [System.Collections.ArrayList]@()
$Global:Courses = [System.Collections.ArrayList]@()
$Global:Groups = [System.Collections.ArrayList]@()
$Global:Sections = [System.Collections.ArrayList]@()

$Global:Proxy = @{}
$Global:ProxyInitialized = $false

$Properties = @{
    Schools = @(
        @{ name = 'title';           	            options = @('default')}    
        @{ name = 'address1';           		    options = @('default')}
        @{ name = 'address2';           		    options = @('default')}
        @{ name = 'city';           			    options = @('default')}
        @{ name = 'state';           			    options = @('default')}
        @{ name = 'postal_code';           		    options = @('default')}
        @{ name = 'country';           			    options = @('default')}
        @{ name = 'website';                        options = @('default')}
        @{ name = 'phone';                          options = @('default')}
        @{ name = 'fax';           			        options = @('default')}
        @{ name = 'building_code';           	    options = @('default')}
    )
    Users = @(
        @{ name = 'uid';           				    options = @('default','key')}    
        @{ name = 'id';           				    options = @('default','update_m','delete_m')}    
        @{ name = 'school_id';           			options = @('default')}
        @{ name = 'synced';           		        options = @('default')}
        @{ name = 'school_uid';           			options = @('default','create_m','update_m')}
        @{ name = 'name_title';           			options = @('default','create','update_o')}
        @{ name = 'name_title_show';           		options = @('default')}
        @{ name = 'name_first';           			options = @('default','create_m','update_o')}
        @{ name = 'name_first_preferred';           options = @('default','create_o','update_o')}
        @{ name = 'use_preferred_first_name';       options = @('default')}
        @{ name = 'name_middle';           			options = @('default','create_o','update_o')}
        @{ name = 'name_middle_show';           	options = @('default','create','update')}
        @{ name = 'name_last';           			options = @('default','create_m','update_o')}
        @{ name = 'name_display';           		options = @('default')}
        @{ name = 'username';           		    options = @('default','create_o','update_o')}
        @{ name = 'primary_email';           		options = @('default','create_o','update_o')}
        @{ name = 'gender';           				options = @('default','create_o','update_o')}
        @{ name = 'position';           			options = @('default','create_o','update_o')}
        @{ name = 'grad_year';           			options = @('default','create_o','update_o')}
        @{ name = 'password';           			options = @('default','create_o','update_o')}
        @{ name = 'role_id';           				options = @('default','create_m','update_o')}
        @{ name = 'parents';           				options = @('default','create_o','update_o')}
        @{ name = 'parent_uids';           			options = @('default','create_o','update_o')} 
        @{ name = 'child_uids';           			options = @('default','create_o','update_o')}
        @{ name = 'language';           			options = @('default','create_o','update_o')}
        @{ name = 'additional_buildings';           options = @('default','create_o','update_o')}
        @{ name = 'parent_access_code';           	options = @('default','delete_o')}
        @{ name = 'option_comment';           	    options = @('default','delete_o')}
        @{ name = 'option_keep_enrollments';        options = @('default','delete_o')}
        @{ name = 'email_notification';           	options = @('default','delete_o')}
    )
     Roles =@(
        @{name ="id";                               options = @('default','key')}
        @{name ="title";                            options = @('default')}
        @{name ="faculty";                          options = @('default')}
        @{name ="role_type";                        options = @('default')}
    )
    Courses =@(
        @{name ="id";                               options = @('default','key')}
        @{name ="title";                            options = @('default','create_m','update_m')}
        @{name ="course_code";                      options = @('default','create_m','update_m')}
        @{name ="department";                       options = @('default','create_o','update_o')}
        @{name ="description";                      options = @('default','create_o','update_o')}
        @{name ="credits";                          options = @('default')}
        @{name ="subject_area";                     options = @('default')}
        @{name ="building_id";                      options = @('default')}
        @{name ="grade_level_range_start";          options = @('default')}
        @{name ="grade_level_range_end";            options = @('default')}

    )
    Sections = @(
        @{name ="id";                               options = @('default','key')}
        @{ name = 'course_title';           		options = @('default')}
        @{ name = 'course_code';           			options = @('default')}
        @{ name = 'course_id';           			options = @('default','create_m')}
        @{ name = 'school_id';           			options = @('default')}
        @{ name = 'access_code';           			options = @('default')}
        @{ name = 'section_title';           		options = @('default','create_o','update_m')}
        @{ name = 'section_code';           		options = @('default','create_o','update_o')}
        @{ name = 'section_school_code';           	options = @('default','create_o','update_o')}
        @{ name = 'active';           				options = @('default')}
        @{ name = 'grading_periods';           		options = @('default','create_m','update_m')}
        @{ name = 'description';           			options = @('default','create_o','update_o')}
        @{ name = 'location';           			options = @('default','create_o','update_o')}
        @{ name = 'meeting_days';           		options = @('default')}
        @{ name = 'start_time';           			options = @('default')}
        @{ name = 'end_time';           			options = @('default')}
        @{ name = 'weight';           				options = @('default')}
        @{ name = 'admin';           				options = @('default')}
    )
    Groups = @(
        @{ name = "id";                             options = @('default','key')}
        @{ name = 'title';           				options = @('default','create_m','update_o')}
        @{ name = 'description';           			options = @('default','create_o','update_o')}
        @{ name = 'website';           				options = @('default','create_o','update_o')}
        @{ name = 'access_code';           			options = @('default')}
        @{ name = 'category';           			options = @('default','create_o','update_o')}
        @{ name = 'options';           				options = @('default')}
        @{ name = 'group_code';           			options = @('default')}
        @{ name = 'privacy_level';           		options = @('default','create_o','update_o')}
        @{ name = 'picture_url';           			options = @('default','update_o')}
        @{ name = 'school_id';           			options = @('default')}
        @{ name = 'building_id';           			options = @('default')}
    )
    GroupEnrollments = @(
        @{ name ="id";                              options = @('default')}
        @{ name = 'uid';           				    options = @('default','create_m','delete_m')}
        @{ name = 'group_id';           			options = @('default','create_m','delete_m')}
        @{ name = 'admin';           				options = @('default')}
        @{ name = 'school_uid';           			options = @('default')}
        @{ name = 'name_title';           			options = @('default')}
        @{ name = 'name_title_show';           		options = @('default')}
        @{ name = 'name_first';           			options = @('default')}
        @{ name = 'name_first_preferred';           options = @('default')}
        @{ name = 'name_middle';           			options = @('default')}
        @{ name = 'name_last';           			options = @('default')}
        @{ name = 'name_display';           		options = @('default')}
        @{ name = 'status';           				options = @('default','update_m','add_m')}
    )
    SectionEnrollments = @(
        @{ name ="id";                              options = @('default')}
        @{ name = 'uid';           				    options = @('default','create_m','update_m')}
        @{ name = 'section_id';           			options = @('default','update_m','delete_m')}
        @{ name = 'admin';           				options = @('default')}
        @{ name = 'school_uid';           			options = @('default')}
        @{ name = 'name_title';           			options = @('default')}
        @{ name = 'name_title_show';           		options = @('default')}
        @{ name = 'name_first';           			options = @('default')}
        @{ name = 'name_first_preferred';           options = @('default')}
        @{ name = 'name_middle';           			options = @('default')}
        @{ name = 'name_last';           			options = @('default')}
        @{ name = 'name_display';           		options = @('default')}
        @{ name = 'status';           				options = @('default','update_m')}
    )
    SectionEvents = @(
        @{ name ="id";                              options = @('default','key')}
        @{ name = 'title';           				options = @('default')}
        @{ name = 'description';           			options = @('default')}
        @{ name = 'start';           				options = @('default')}
        @{ name = 'has_end';           				options = @('default')}
        @{ name = 'end';           				    options = @('default')}
        @{ name = 'all_day';           				options = @('default')}
        @{ name = 'editable';           			options = @('default')}
        @{ name = 'rsvp';           				options = @('default')}
        @{ name = 'comments_enabled';           	options = @('default')}
        @{ name = 'type';           				options = @('default')}
        @{ name = 'realm';           				options = @('default')}
        @{ name = 'section_id';           			options = @('default')}

    )
    GroupEvents = @(
        @{ name ="id";                              options = @('default','key')}
        @{ name = 'title';           				options = @('default')}
        @{ name = 'description';           			options = @('default')}
        @{ name = 'start';           				options = @('default')}
        @{ name = 'has_end';           				options = @('default')}
        @{ name = 'end';           				    options = @('default')}
        @{ name = 'all_day';           				options = @('default')}
        @{ name = 'editable';           			options = @('default')}
        @{ name = 'rsvp';           				options = @('default')}
        @{ name = 'comments_enabled';           	options = @('default')}
        @{ name = 'type';           				options = @('default')}
        @{ name = 'realm';           				options = @('default')}
        @{ name = 'group_id';           			options = @('default')}

    )
    GradingPeriods = @(
        @{ name ="id";                              options = @('default','key')}
        @{ name = 'title';           				options = @('default')}
        @{ name = 'start';           				options = @('default')}
        @{ name = 'end';           				    options = @('default')}
        @{ name = 'active';           				options = @('default')}
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
                name = 'nr_of_threads'
                type = 'textbox'
                label = 'Max. number of simultaneous requests'
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
    $Global:AuthToken = $null
    $Global:Proxy = @{}
    $Global:ProxyInitialized = $false
    $Global:Users.Clear()
    $Global:Courses.Clear()
    $Global:Groups.Clear()
    $Global:Sections.Clear()
}

#
# Object CRUD functions
#


# Read Functions Begin
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
                    ResponseProperty = 'school'
                }
                ((Execute-Request @splat) )

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

                $Global:Users.AddRange(@() + (Execute-Request @splat) )
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

function Idm-RolesRead {
    param (
        # Mode
        [switch] $GetMeta,    
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams

    )
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams
        $Class = 'Roles'
        
        if ($GetMeta) {
            Get-ClassMetaData -SystemParams $SystemParams -Class $Class
            
        } else {
                $uri = "v1/roles"
                
                $splat = @{
                    SystemParams = $system_params
                    Method = "GET"
                    Uri = $uri                    
                    Body = $null
                    ResponseProperty = 'role'
                }

            $response = (Execute-Request @splat)          
            $properties = ($Global:Properties.$Class).name
            $hash_table = [ordered]@{}

            foreach ($prop in $properties.GetEnumerator()) {
                $hash_table[$prop] = ""
            }

            foreach($rowItem in $response) {
                $row = New-Object -TypeName PSObject -Property $hash_table

                foreach($prop in $rowItem.PSObject.properties) {
                    if(!$properties.contains($prop.Name)) { continue }
                    $row.($prop.Name) = $prop.Value
                }

                $row
            }
            
        }
}

function Idm-GradingPeriodsRead {
    param (
        # Mode
        [switch] $GetMeta,    
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams

    )
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams
        $Class = 'GradingPeriods'
        
        if ($GetMeta) {
            Get-ClassMetaData -SystemParams $SystemParams -Class $Class
            
        } else {
                $uri = "v1/gradingperiods"
                
                $splat = @{
                    SystemParams = $system_params
                    Method = "GET"
                    Uri = $uri                    
                    Body = $null
                    ResponseProperty = 'gradingperiods'
                }

            $response = (Execute-Request @splat)          
            $properties = ($Global:Properties.$Class).name
            $hash_table = [ordered]@{}

            foreach ($prop in $properties.GetEnumerator()) {
                $hash_table[$prop] = ""
            }

            foreach($rowItem in $response) {
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

                $Global:Groups.AddRange(@() + (Execute-Request @splat) )
                $Global:GroupsCacheTime = Get-Date
            }
            
            $properties = ($Global:Properties.$Class).name
            $hash_table = [ordered]@{}

            foreach ($prop in $properties.GetEnumerator()) {
                $hash_table[$prop] = ""
            }

            foreach($rowItem in $Global:Groups) {
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

                $Global:Courses.AddRange(@() + (Execute-Request @splat) )
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
            return
        }

        # Refresh cache if needed
        if ($Global:Courses.Count -eq 0) {
            Idm-GroupsRead -SystemParams $SystemParams -FunctionParams $FunctionParams | Out-Null
        }
        $Global:SectionsCacheTime = Get-Date
        # Precompute property template
        $properties = $Global:Properties.$Class | Where-Object { ('hidden' -notin $_.options ) }
        $propertiesHT = @{}; $Global:Properties.$Class | ForEach-Object { $propertiesHT[$_.name] = $_ }

        $template = [ordered]@{}
        foreach ($prop in $properties.Name) {
            $template[$prop] = $null
        }

        # Prepare runspace pool
        $cancellationSource = [System.Threading.CancellationTokenSource]::new()

        $runspacePool = [runspacefactory]::CreateRunspacePool(1, [int]$system_params.nr_of_threads)
        $runspacePool.Open()
        $runspaces = [System.Collections.Generic.List[PSCustomObject]]::new()

        # Index for tracking
        $index = 0

        $funcDef = "function Execute-Request { $((Get-Command Execute-Request -CommandType Function).ScriptBlock.ToString()) }"
        $funcDef2 = "function Execute-Authorization { $((Get-Command Execute-Authorization -CommandType Function).ScriptBlock.ToString()) }"
        
        # Capture once — stable for the entire sync
        $proxySnapshot           = if ($Global:Proxy) { $Global:Proxy.Clone() } else { $null }
        $authTokenSnapshot       = $Global:AuthToken
        $proxyInitializedSnapshot = $Global:ProxyInitialized

        foreach($item in $Global:Courses){
            $runspace = [powershell]::Create()
            [void]$runspace.AddScript($funcDef).AddScript($funcDef2).AddScript({
                param($item, $system_params, $Class, $index, $proxy, $authToken, $proxyInitialized)
            
                $Global:Proxy            = $proxy
                $Global:AuthToken        = $authToken
                $Global:ProxyInitialized = $proxyInitialized

                $itemResult = @{
                    rows = [System.Collections.ArrayList]@()
                    logMessage = $null
                }
                                  
                $uri = ("v1/courses/{0}/sections" -f $item.id)
            
                $splat = @{
                    SystemParams = $system_params
                    Method = "GET"
                    Uri = $uri                    
                    Body = $null
                    ResponseProperty = 'section'
                    LogMessage = "[$($item.ID)]"
                    LoggingEnabled = $false
                }

                try {
                    $response = Execute-Request @splat
                } catch {
                    $itemResult.logMessage = "Retrieve Course Sections [$($item.ID)] - $_"
                    return $itemResult
                }


                [void]$itemResult.rows.AddRange(@() + $response)
                return $itemResult
            }).AddArgument($item).AddArgument($system_params).AddArgument($Class).AddArgument($index).AddArgument($proxySnapshot).AddArgument($authTokenSnapshot).AddArgument($proxyInitializedSnapshot)

            $runspace.RunspacePool = $runspacePool
            $runspaces.Add([PSCustomObject]@{ Pipe = $runspace; Status = $runspace.BeginInvoke(); Index = $index })

            $index++
        }

        # Collect results
        $total = $runspaces.Count
        $completed = 0

        while ($runspaces.Count -gt 0) {
            for ($i = $runspaces.Count - 1; $i -ge 0; $i--) {
                $r = $runspaces[$i]
                if (-not $r.Status.IsCompleted) { continue }

                $output = $r.Pipe.EndInvoke($r.Status)
                $completed++

                if ($completed % 250 -eq 0 -or $completed -eq $total) {
                    $percent = [math]::Round(($completed / $total) * 100, 2)
                    Log info "Progress: [$completed/$total] requests completed ($percent%)"
                }

                if($null -ne $output.logMessage) {
                    Log verbose $output.logMessage
                }

                foreach($rowItem in $output.rows) {
                    $row = New-Object -TypeName PSObject -Property ([ordered]@{} + $template)
                    foreach($prop in $rowItem.PSObject.properties) {
                        if(!$properties.Name.contains($prop.Name)) { continue }
                        $row.($prop.Name) = $prop.Value
                    }

                    [void]$Global:Sections.Add($row)
                }

                $r.Pipe.Dispose()
                $runspaces.RemoveAt($i)
            } 
            if ($runspaces.Count -gt 0) { Start-Sleep -Milliseconds 2500 }
        }

        $runspacePool.Close()
        $runspacePool.Dispose()
        $cancellationSource.Dispose()

        $Global:Sections | Sort-Object id -Unique
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
            return
        }

        # Refresh cache if needed
        if ($Global:Groups.Count -eq 0) {
            Idm-GroupsRead -SystemParams $SystemParams -FunctionParams $FunctionParams | Out-Null
        }

        # Precompute property template
        $properties = $Global:Properties.$Class | Where-Object { ('hidden' -notin $_.options ) }
        $propertiesHT = @{}; $Global:Properties.$Class | ForEach-Object { $propertiesHT[$_.name] = $_ }

        $template = [ordered]@{}
        foreach ($prop in $properties.Name) {
            $template[$prop] = $null
        }

        # Prepare runspace pool
        $cancellationSource = [System.Threading.CancellationTokenSource]::new()

        $runspacePool = [runspacefactory]::CreateRunspacePool(1, [int]$system_params.nr_of_threads)
        $runspacePool.Open()
        $runspaces = [System.Collections.Generic.List[PSCustomObject]]::new()

        # Index for tracking
        $index = 0

        $funcDef = "function Execute-Request { $((Get-Command Execute-Request -CommandType Function).ScriptBlock.ToString()) }"
        $funcDef2 = "function Execute-Authorization { $((Get-Command Execute-Authorization -CommandType Function).ScriptBlock.ToString()) }"
        
        # Capture once — stable for the entire sync
        $proxySnapshot           = if ($Global:Proxy) { $Global:Proxy.Clone() } else { $null }
        $authTokenSnapshot       = $Global:AuthToken
        $proxyInitializedSnapshot = $Global:ProxyInitialized

        foreach($item in $Global:Groups){
            $runspace = [powershell]::Create()
            [void]$runspace.AddScript($funcDef).AddScript($funcDef2).AddScript({
                param($item, $system_params, $Class, $index, $proxy, $authToken, $proxyInitialized)
            
                $Global:Proxy            = $proxy
                $Global:AuthToken        = $authToken
                $Global:ProxyInitialized = $proxyInitialized
                
                $itemResult = @{
                    rows = [System.Collections.ArrayList]@()
                    logMessage = $null
                }

                $uri = ("v1/groups/{0}/enrollments" -f $item.id)
            
                $splat = @{
                    SystemParams = $system_params
                    Method = "GET"
                    Uri = $uri                    
                    Body = $null
                    ResponseProperty = 'enrollment'
                    LogMessage = "[$($item.ID)]"
                    LoggingEnabled = $false
                }

                try {
                    $response = Execute-Request @splat
                } catch {
                    $itemResult.logMessage = "Retrieve Group Memberships [$($item.ID)] - $_"
                    return $itemResult
                }


                $enriched = $response | ForEach-Object { $_ | Add-Member -NotePropertyName 'group_id' -NotePropertyValue $item.id -PassThru }
                [void]$itemResult.rows.AddRange(@() + $enriched)
                return $itemResult
            }).AddArgument($item).AddArgument($system_params).AddArgument($Class).AddArgument($index).AddArgument($proxySnapshot).AddArgument($authTokenSnapshot).AddArgument($proxyInitializedSnapshot)
    
            $runspace.RunspacePool = $runspacePool
            $runspaces.Add([PSCustomObject]@{ Pipe = $runspace; Status = $runspace.BeginInvoke(); Index = $index })

            $index++
        }

        # Collect results
        $total = $runspaces.Count
        $completed = 0

        while ($runspaces.Count -gt 0) {
            for ($i = $runspaces.Count - 1; $i -ge 0; $i--) {
                $r = $runspaces[$i]
                if (-not $r.Status.IsCompleted) { continue }

                $output = $r.Pipe.EndInvoke($r.Status)
                $completed++

                if ($completed % 250 -eq 0 -or $completed -eq $total) {
                    $percent = [math]::Round(($completed / $total) * 100, 2)
                    Log info "Progress: [$completed/$total] requests completed ($percent%)"
                }

                if($null -ne $output.logMessage) {
                    Log verbose $output.logMessage
                }

                foreach($rowItem in $output.rows) {
                    $row = New-Object -TypeName PSObject -Property ([ordered]@{} + $template)
                    foreach($prop in $rowItem.PSObject.properties) {
                        if(!$properties.Name.contains($prop.Name)) { continue }
                        $row.($prop.Name) = $prop.Value
                    }

                    $row
                }
            
            $r.Pipe.Dispose()
                $runspaces.RemoveAt($i)
            } 
            if ($runspaces.Count -gt 0) { Start-Sleep -Milliseconds 2500 }
        }

        $runspacePool.Close()
        $runspacePool.Dispose()
        $cancellationSource.Dispose()
}

function Idm-SectionEnrollmentsRead {
    param (
        # Mode
        [switch] $GetMeta,    
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams

    )
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams
        $Class = 'SectionEnrollments'
        
        if ($GetMeta) {
            Get-ClassMetaData -SystemParams $SystemParams -Class $Class
            return
        }

        # Refresh cache if needed
        if ($Global:Sections.Count -eq 0) {
            Idm-SectionsRead -SystemParams $SystemParams -FunctionParams $FunctionParams | Out-Null
        }

        # Precompute property template
        $properties = $Global:Properties.$Class | Where-Object { ('hidden' -notin $_.options ) }
        $propertiesHT = @{}; $Global:Properties.$Class | ForEach-Object { $propertiesHT[$_.name] = $_ }

        $template = [ordered]@{}
        foreach ($prop in $properties.Name) {
            $template[$prop] = $null
        }

        # Prepare runspace pool
        $cancellationSource = [System.Threading.CancellationTokenSource]::new()

        $runspacePool = [runspacefactory]::CreateRunspacePool(1, [int]$system_params.nr_of_threads)
        $runspacePool.Open()
        $runspaces = [System.Collections.Generic.List[PSCustomObject]]::new()

        # Index for tracking
        $index = 0

        $funcDef = "function Execute-Request { $((Get-Command Execute-Request -CommandType Function).ScriptBlock.ToString()) }"
        $funcDef2 = "function Execute-Authorization { $((Get-Command Execute-Authorization -CommandType Function).ScriptBlock.ToString()) }"
        
        # Capture once — stable for the entire sync
        $proxySnapshot           = if ($Global:Proxy) { $Global:Proxy.Clone() } else { $null }
        $authTokenSnapshot       = $Global:AuthToken
        $proxyInitializedSnapshot = $Global:ProxyInitialized

        foreach($item in $Global:Sections){
            $runspace = [powershell]::Create()
            [void]$runspace.AddScript($funcDef).AddScript($funcDef2).AddScript({
                param($item, $system_params, $Class, $index, $proxy, $authToken, $proxyInitialized)
            
                $Global:Proxy            = $proxy
                $Global:AuthToken        = $authToken
                $Global:ProxyInitialized = $proxyInitialized
                
                $itemResult = @{
                    rows = [System.Collections.ArrayList]@()
                    logMessage = $null
                }

                $uri = ("v1/Section/{0}/enrollments" -f $item.id)
                
                $splat = @{
                    SystemParams = $system_params
                    Method = "GET"
                    Uri = $uri                    
                    Body = $null
                    ResponseProperty = 'enrollment'
                    LogMessage = "[$($item.ID)]"
                    LoggingEnabled = $false
                }

                try {
                    $response = Execute-Request @splat
                } catch {
                    $itemResult.logMessage = "Retrieve Group Memberships [$($item.ID)] - $_"
                    return $itemResult
                }


                $enriched = $response | ForEach-Object { $_ | Add-Member -NotePropertyName 'section_id' -NotePropertyValue $item.id -PassThru }
                [void]$itemResult.rows.AddRange(@() + $enriched)
                return $itemResult
            }).AddArgument($item).AddArgument($system_params).AddArgument($Class).AddArgument($index).AddArgument($proxySnapshot).AddArgument($authTokenSnapshot).AddArgument($proxyInitializedSnapshot)

            $runspace.RunspacePool = $runspacePool
            $runspaces.Add([PSCustomObject]@{ Pipe = $runspace; Status = $runspace.BeginInvoke(); Index = $index })

            $index++
        }

        # Collect results
        $total = $runspaces.Count
        $completed = 0

        while ($runspaces.Count -gt 0) {
            for ($i = $runspaces.Count - 1; $i -ge 0; $i--) {
                $r = $runspaces[$i]
                if (-not $r.Status.IsCompleted) { continue }

                $output = $r.Pipe.EndInvoke($r.Status)
                $completed++

                if ($completed % 250 -eq 0 -or $completed -eq $total) {
                    $percent = [math]::Round(($completed / $total) * 100, 2)
                    Log info "Progress: [$completed/$total] requests completed ($percent%)"
                }

            if($null -ne $output.logMessage) {
                Log verbose $output.logMessage
            }

            foreach($rowItem in $output.rows) {
                $row = New-Object -TypeName PSObject -Property ([ordered]@{} + $template)
                foreach($prop in $rowItem.PSObject.properties) {
                    if(!$properties.Name.contains($prop.Name)) { continue }
                    $row.($prop.Name) = $prop.Value
                }

                $row
            }
            
            $r.Pipe.Dispose()
                $runspaces.RemoveAt($i)
            } 
            if ($runspaces.Count -gt 0) { Start-Sleep -Milliseconds 2500 }
        }

        $runspacePool.Close()
        $runspacePool.Dispose()
        $cancellationSource.Dispose()
}

function Idm-GroupEventsRead {
    param (
        # Mode
        [switch] $GetMeta,    
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams

    )
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams
        $Class = 'GroupEvents'
        
        if ($GetMeta) {
            Get-ClassMetaData -SystemParams $SystemParams -Class $Class
            return
        }

        # Refresh cache if needed
        if ($Global:Groups.Count -eq 0) {
            Idm-GroupsRead -SystemParams $SystemParams -FunctionParams $FunctionParams | Out-Null
        }

        # Precompute property template
        $properties = $Global:Properties.$Class | Where-Object { ('hidden' -notin $_.options ) }
        $propertiesHT = @{}; $Global:Properties.$Class | ForEach-Object { $propertiesHT[$_.name] = $_ }

        $template = [ordered]@{}
        foreach ($prop in $properties.Name) {
            $template[$prop] = $null
        }

        # Prepare runspace pool
        $cancellationSource = [System.Threading.CancellationTokenSource]::new()

        $runspacePool = [runspacefactory]::CreateRunspacePool(1, [int]$system_params.nr_of_threads)
        $runspacePool.Open()
        $runspaces = [System.Collections.Generic.List[PSCustomObject]]::new()

        # Index for tracking
        $index = 0

        $funcDef = "function Execute-Request { $((Get-Command Execute-Request -CommandType Function).ScriptBlock.ToString()) }"
        $funcDef2 = "function Execute-Authorization { $((Get-Command Execute-Authorization -CommandType Function).ScriptBlock.ToString()) }"
        
        # Capture once — stable for the entire sync
        $proxySnapshot           = if ($Global:Proxy) { $Global:Proxy.Clone() } else { $null }
        $authTokenSnapshot       = $Global:AuthToken
        $proxyInitializedSnapshot = $Global:ProxyInitialized

        foreach($item in $Global:Groups){
            $runspace = [powershell]::Create()
            [void]$runspace.AddScript($funcDef).AddScript($funcDef2).AddScript({
                param($item, $system_params, $Class, $index, $proxy, $authToken, $proxyInitialized)
            
                $Global:Proxy            = $proxy
                $Global:AuthToken        = $authToken
                $Global:ProxyInitialized = $proxyInitialized
                
                $itemResult = @{
                    rows = [System.Collections.ArrayList]@()
                    logMessage = $null
                }

                $uri = ("v1/groups/{0}/events" -f $item.id)
            
                $splat = @{
                    SystemParams = $system_params
                    Method = "GET"
                    Uri = $uri                    
                    Body = $null
                    ResponseProperty = 'event'
                    LogMessage = "[$($item.ID)]"
                    LoggingEnabled = $false
                }

                try {
                    $response = Execute-Request @splat
                    
                } catch {
                    $itemResult.logMessage = "Retrieve Section Events [$($item.ID)] - $_"
                    return $itemResult
                }

                [void]$itemResult.rows.AddRange(@() + $response)
                return $itemResult
            }).AddArgument($item).AddArgument($system_params).AddArgument($Class).AddArgument($index).AddArgument($proxySnapshot).AddArgument($authTokenSnapshot).AddArgument($proxyInitializedSnapshot)

            $runspace.RunspacePool = $runspacePool
            $runspaces.Add([PSCustomObject]@{ Pipe = $runspace; Status = $runspace.BeginInvoke(); Index = $index })

            $index++
        }

       # Collect results
        $total = $runspaces.Count
        $completed = 0

        while ($runspaces.Count -gt 0) {
            for ($i = $runspaces.Count - 1; $i -ge 0; $i--) {
                $r = $runspaces[$i]
                if (-not $r.Status.IsCompleted) { continue }

                $output = $r.Pipe.EndInvoke($r.Status)
                $completed++

                if ($completed % 250 -eq 0 -or $completed -eq $total) {
                    $percent = [math]::Round(($completed / $total) * 100, 2)
                    Log info "Progress: [$completed/$total] requests completed ($percent%)"
                }

            if($null -ne $output.logMessage) {
                Log verbose $output.logMessage
            }

            foreach($rowItem in $output.rows) {
                $row = New-Object -TypeName PSObject -Property ([ordered]@{} + $template)
                foreach($prop in $rowItem.PSObject.properties) {
                    if(!$properties.Name.contains($prop.Name)) { continue }
                    $row.($prop.Name) = $prop.Value
                }

                $row
            }
            
            $r.Pipe.Dispose()
                $runspaces.RemoveAt($i)
            } 
            if ($runspaces.Count -gt 0) { Start-Sleep -Milliseconds 2500 }
        }

        $runspacePool.Close()
        $runspacePool.Dispose()
        $cancellationSource.Dispose()
}
# Read Functions End


#Create Functions Begin
function Idm-UsersCreate {
    param (
        # Operations
        [switch] $GetMeta,
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams
    )

    Log info "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"
    $Class = 'Users'

    if ($GetMeta) {
        #
        # Get meta data
        #
        @{
            semantics = 'create'
            parameters = @(
                ($Global:Properties.$Class | Where-Object { $_.options.Contains('create_m') }) | ForEach-Object {
                    @{ name = $_.name;  allowance = 'mandatory' }
                }

                ($Global:Properties.$Class | Where-Object { $_.options.Contains('create_o') -or $_.options.Contains('optional') }) | ForEach-Object {
                    @{ name = $_.name;  allowance = 'optional' }
                }

                $Global:Properties.$Class | Where-Object { !$_.options.Contains('create_m') -and !$_.options.Contains('create_o') -and !$_.options.Contains('optional') } | ForEach-Object {
                    @{ name = $_.name; allowance = 'prohibited' }
                }
            )
        }
    }
    else {
        #
        # Execute function
        #
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams

        $uri = "v1/users"

        $splat = @{
            SystemParams = $system_params
            Method = "POST"
            Uri = $uri                    
            Body = ($function_params | ConvertTo-Json)
        }

        Execute-Request @splat

    }

    Log info "Done"
}

function Idm-GroupsCreate {
    param (
        # Operations
        [switch] $GetMeta,
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams
    )

    Log info "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"
    $Class = 'Groups'

    if ($GetMeta) {
        #
        # Get meta data
        #
        @{
            semantics = 'create'
            parameters = @(
                ($Global:Properties.$Class | Where-Object { $_.options.Contains('create_m') }) | ForEach-Object {
                    @{ name = $_.name;  allowance = 'mandatory' }
                }

                ($Global:Properties.$Class | Where-Object { $_.options.Contains('create_o') -or $_.options.Contains('optional') }) | ForEach-Object {
                    @{ name = $_.name;  allowance = 'optional' }
                }

                $Global:Properties.$Class | Where-Object { !$_.options.Contains('create_m') -and !$_.options.Contains('create_o') -and !$_.options.Contains('optional') } | ForEach-Object {
                    @{ name = $_.name; allowance = 'prohibited' }
                }
            )
        }
    }
    else {
        #
        # Execute function
        #
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams

        $uri = "v1/groups"

        $splat = @{
            SystemParams = $system_params
            Method = "POST"
            Uri = $uri                    
            Body = ($function_params | ConvertTo-Json)
        }

        Execute-Request @splat

    }

    Log info "Done"
}

function Idm-CoursesCreate {
    param (
        # Operations
        [switch] $GetMeta,
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams
    )

    Log info "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"
    $Class = 'Courses'

    if ($GetMeta) {
        #
        # Get meta data
        #
        @{
            semantics = 'create'
            parameters = @(
                ($Global:Properties.$Class | Where-Object { $_.options.Contains('create_m') }) | ForEach-Object {
                    @{ name = $_.name;  allowance = 'mandatory' }
                }

                ($Global:Properties.$Class | Where-Object { $_.options.Contains('create_o') -or $_.options.Contains('optional') }) | ForEach-Object {
                    @{ name = $_.name;  allowance = 'optional' }
                }

                $Global:Properties.$Class | Where-Object { !$_.options.Contains('create_m') -and !$_.options.Contains('create_o') -and !$_.options.Contains('optional') } | ForEach-Object {
                    @{ name = $_.name; allowance = 'prohibited' }
                }
            )
        }
    }
    else {
        #
        # Execute function
        #
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams

        $uri = "v1/courses"

        $splat = @{
            SystemParams = $system_params
            Method = "POST"
            Uri = $uri                    
            Body = ($function_params | ConvertTo-Json)
        }

        Execute-Request @splat

    }

    Log info "Done"
}

function Idm-SectionsCreate {
    param (
        # Operations
        [switch] $GetMeta,
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams
    )

    Log info "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"
    $Class = 'Sections'

    if ($GetMeta) {
        #
        # Get meta data
        #
        @{
            semantics = 'create'
            parameters = @(
                ($Global:Properties.$Class | Where-Object { $_.options.Contains('create_m') }) | ForEach-Object {
                    @{ name = $_.name;  allowance = 'mandatory' }
                }

                ($Global:Properties.$Class | Where-Object { $_.options.Contains('create_o') -or $_.options.Contains('optional') }) | ForEach-Object {
                    @{ name = $_.name;  allowance = 'optional' }
                }

                $Global:Properties.$Class | Where-Object { !$_.options.Contains('create_m') -and !$_.options.Contains('create_o') -and !$_.options.Contains('optional') } | ForEach-Object {
                    @{ name = $_.name; allowance = 'prohibited' }
                }
            )
        }
    }
    else {
        #
        # Execute function
        #
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams

        $uri = ("v1/courses/{0}/sections" -f $function_params.course_id)

        $splat = @{
            SystemParams = $system_params
            Method = "POST"
            Uri = $uri                    
            Body = ($function_params | ConvertTo-Json)
        }

        Execute-Request @splat

    }

    Log info "Done"
}

function Idm-GroupEnrollmentsCreate {
    param (
        # Operations
        [switch] $GetMeta,
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams
    )

    Log info "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"
    $Class = 'GroupEnrollments'

    if ($GetMeta) {
        #
        # Get meta data
        #
        @{
            semantics = 'create'

            parameters = @(
                ($Global:Properties.$Class | Where-Object { $_.options.Contains('create_m') }) | ForEach-Object {
                    @{ name = $_.name;  allowance = 'mandatory' }
                }

                ($Global:Properties.$Class | Where-Object {  $_.options.Contains('create_o') -or $_.options.Contains('optional') }) | ForEach-Object {
                    @{ name = $_.name;  allowance = 'optional' }
                }

                $Global:Properties.$Class | Where-Object { !$_.options.Contains('create_m') -and !$_.options.Contains('create_o') -and !$_.options.Contains('optional') } | ForEach-Object {
                    @{ name = $_.name; allowance = 'prohibited' }
                }
            )
        }
    }
    else {
        #
        # Execute function
        #
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams

        $uri = "v1/groups/{0}/enrollments" -f $function_params.group_id

        $splat = @{
            SystemParams = $system_params
            Method = "POST"
            Uri = $uri                    
            Body = ($function_params | ConvertTo-Json)
        }

        Execute-Request @splat

    }

    Log info "Done"
}

function Idm-SectionEnrollmentsCreate {
    param (
        # Operations
        [switch] $GetMeta,
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams
    )

    Log info "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"
    $Class = 'SectionEnrollments'

    if ($GetMeta) {
        #
        # Get meta data
        #
        @{
            semantics = 'create'
            parameters = @(
                ($Global:Properties.$Class | Where-Object { $_.options.Contains('create_m') }) | ForEach-Object {
                    @{ name = $_.name;  allowance = 'mandatory' }
                }

                ($Global:Properties.$Class | Where-Object { $_.options.Contains('create_o') -or $_.options.Contains('optional') }) | ForEach-Object {
                    @{ name = $_.name;  allowance = 'optional' }
                }

                $Global:Properties.$Class | Where-Object { !$_.options.Contains('create_m') -and !$_.options.Contains('create_o') -and !$_.options.Contains('optional') } | ForEach-Object {
                    @{ name = $_.name; allowance = 'prohibited' }
                }
            )
        }
    }
    else {
        #
        # Execute function
        #
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams

        $uri = "v1/sections/{0}/enrollments" -f $function_params.section_id

        $splat = @{
            SystemParams = $system_params
            Method = "POST"
            Uri = $uri                    
            Body = ($function_params | ConvertTo-Json)
        }

        Execute-Request @splat

    }

    Log info "Done"
}
#Create Functions End

#Update Functions Begin
function Idm-UsersUpdate {
    param (
        # Operations
        [switch] $GetMeta,
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams
    )

    Log info "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"
    $Class = 'Users'

    if ($GetMeta) {
        #
        # Get meta data
        #
        @{
            semantics = 'update'
            parameters = @(
                ($Global:Properties.$Class | Where-Object { $_.options.Contains('update_m') -or $_.options -contains 'key'}) | ForEach-Object {
                    @{ name = $_.name;  allowance = 'mandatory' }
                }

                ($Global:Properties.$Class | Where-Object { $_.options.Contains('update_o') -or $_.options.Contains('optional') }) | ForEach-Object {
                    @{ name = $_.name;  allowance = 'optional' }
                }

                $Global:Properties.$Class | Where-Object { !$_.options.Contains('update_m') -and !$_.options.Contains('update_o') -and !$_.options.Contains('optional') } | ForEach-Object {
                    @{ name = $_.name; allowance = 'prohibited' }
                }
            )
        }
    }
    else {
        #
        # Execute function
        #
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams

        $uri = "v1/users/{0}" -f $function_params.id

        $splat = @{
            SystemParams = $system_params
            Method = "PUT"
            Uri = $uri                    
            Body = ($function_params | ConvertTo-Json)
        }

        Execute-Request @splat

    }

    Log info "Done"
}

function Idm-GroupsUpdate {
    param (
        # Operations
        [switch] $GetMeta,
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams
    )

    Log info "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"
    $Class = 'Groups'

    if ($GetMeta) {
        #
        # Get meta data
        #
        @{
            semantics = 'update'
            parameters = @(
                ($Global:Properties.$Class | Where-Object { $_.options.Contains('update_m') -or $_.options -contains 'key'}) | ForEach-Object {
                    @{ name = $_.name;  allowance = 'mandatory' }
                }

                ($Global:Properties.$Class | Where-Object { $_.options.Contains('update_o') -or $_.options.Contains('optional') }) | ForEach-Object {
                    @{ name = $_.name;  allowance = 'optional' }
                }

                 $Global:Properties.$Class | Where-Object { !$_.options.Contains('update_m') -and !$_.options.Contains('update_o') -and !$_.options.Contains('optional') -and !$_.options.Contains('key') }  | ForEach-Object {
                    @{ name = $_.name; allowance = 'prohibited' }
                }
            )
        }
    }
    else {
        #
        # Execute function
        #
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams

        $uri = "v1/groups/{0}" -f $function_params.id

        $splat = @{
            SystemParams = $system_params
            Method = "PUT"
            Uri = $uri                    
            Body = ($function_params | ConvertTo-Json)
        }

        Execute-Request @splat

    }

    Log info "Done"
}

function Idm-CoursesUpdate {
    param (
        # Operations
        [switch] $GetMeta,
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams
    )

    Log info "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"
    $Class = 'Courses'

    if ($GetMeta) {
        #
        # Get meta data
        #
        @{
            semantics = 'update'
            parameters = @(
                ($Global:Properties.$Class | Where-Object { $_.options.Contains('update_m') -or $_.options -contains 'key'}) | ForEach-Object {
                    @{ name = $_.name;  allowance = 'mandatory' }
                }

                ($Global:Properties.$Class | Where-Object { $_.options.Contains('update_o') -or $_.options.Contains('optional') }) | ForEach-Object {
                    @{ name = $_.name;  allowance = 'optional' }
                }

                $Global:Properties.$Class | Where-Object { !$_.options.Contains('update_m') -and !$_.options.Contains('update_o') -and !$_.options.Contains('optional') -and !$_.options.Contains('key') }  | ForEach-Object {
                    @{ name = $_.name; allowance = 'prohibited' }
                }
            )
        }
    }
    else {
        #
        # Execute function
        #
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams

        $uri = "v1/courses/{0}" -f $function_params.id

        $splat = @{
            SystemParams = $system_params
            Method = "PUT"
            Uri = $uri                    
            Body = ($function_params | ConvertTo-Json)
        }

        Execute-Request @splat

    }

    Log info "Done"
}

function Idm-SectionsUpdate {
    param (
        # Operations
        [switch] $GetMeta,
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams
    )

    Log info "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"
    $Class = 'Sections'

    if ($GetMeta) {
        #
        # Get meta data
        #
        @{
            semantics = 'update'
            parameters = @(
                ($Global:Properties.$Class | Where-Object { $_.options.Contains('update_m') -or $_.options -contains 'key'}) | ForEach-Object {
                    @{ name = $_.name;  allowance = 'mandatory' }
                }

                ($Global:Properties.$Class | Where-Object { $_.options.Contains('update_o') -or $_.options.Contains('optional') }) | ForEach-Object {
                    @{ name = $_.name;  allowance = 'optional' }
                }

                $Global:Properties.$Class | Where-Object { !$_.options.Contains('update_m') -and !$_.options.Contains('update_o') -and !$_.options.Contains('optional') -and !$_.options.Contains('key') }  | ForEach-Object {
                    @{ name = $_.name; allowance = 'prohibited' }
                }
            )
        }
    }
    else {
        #
        # Execute function
        #
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams

        $uri = "v1/sections/{0}" -f $function_params.id

        $splat = @{
            SystemParams = $system_params
            Method = "PUT"
            Uri = $uri                    
            Body = ($function_params | ConvertTo-Json)
        }

        Execute-Request @splat

    }

    Log info "Done"
}
#Update Functions End

#Delete Functions Begin
function Idm-UsersDelete {
    param (
        # Operations
        [switch] $GetMeta,
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams
    )

    Log info "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"
    $Class = 'Users'

    if ($GetMeta) {
        #
        # Get meta data
        #
        @{
            semantics = 'delete'
            parameters = @(
                ($Global:Properties.$Class | Where-Object { $_.options.Contains('delete_m') -or $_.options -contains 'key'}) | ForEach-Object {
                    @{ name = $_.name;  allowance = 'mandatory' }
                }

                ($Global:Properties.$Class | Where-Object { $_.options.Contains('delete_o') -or $_.options.Contains('optional') }) | ForEach-Object {
                    @{ name = $_.name;  allowance = 'optional' }
                }

                $Global:Properties.$Class | Where-Object { !$_.options.Contains('delete_m') -and !$_.options.Contains('delete_o') -and !$_.options.Contains('optional') } | ForEach-Object {
                    @{ name = $_.name; allowance = 'prohibited' }
                }
            )
        }
    }
    else {
        #
        # Execute function
        #
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams

        $uri = "v1/users/{0}" -f $function_params.id

        $splat = @{
            SystemParams = $system_params
            Method = "DELETE"
            Uri = $uri                    
            Body = ($function_params | ConvertTo-Json)
        }

        Execute-Request @splat

    }

    Log info "Done"
}

function Idm-GroupsDelete {
    param (
        # Operations
        [switch] $GetMeta,
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams
    )

    Log info "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"
    $Class = 'Groups'

    if ($GetMeta) {
        #
        # Get meta data
        #
        @{
            semantics = 'delete'
            parameters = @(
                ($Global:Properties.$Class | Where-Object { $_.options.Contains('delete_m') -or $_.options -contains 'key'}) | ForEach-Object {
                    @{ name = $_.name;  allowance = 'mandatory' }
                }

                ($Global:Properties.$Class | Where-Object { $_.options.Contains('delete_o') -or $_.options.Contains('optional') }) | ForEach-Object {
                    @{ name = $_.name;  allowance = 'optional' }
                }

                 $Global:Properties.$Class | Where-Object { !$_.options.Contains('delete_m') -and !$_.options.Contains('delete_o') -and !$_.options.Contains('optional') -and !$_.options.Contains('key') }  | ForEach-Object {
                    @{ name = $_.name; allowance = 'prohibited' }
                }
            )
        }
    }
    else {
        #
        # Execute function
        #
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams

        $uri = "v1/groups/{0}" -f $function_params.id

        $splat = @{
            SystemParams = $system_params
            Method = "DELETE"
            Uri = $uri                    
            Body = ($function_params | ConvertTo-Json)
        }

        Execute-Request @splat

    }

    Log info "Done"
}


function Idm-CoursesDelete {
    param (
        # Operations
        [switch] $GetMeta,
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams
    )

    Log info "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"
    $Class = 'Courses'

    if ($GetMeta) {
        #
        # Get meta data
        #
        @{
            semantics = 'delete'
            parameters = @(
                ($Global:Properties.$Class | Where-Object { $_.options.Contains('delete_m') -or $_.options -contains 'key'}) | ForEach-Object {
                    @{ name = $_.name;  allowance = 'mandatory' }
                }

                ($Global:Properties.$Class | Where-Object { $_.options.Contains('delete_o') -or $_.options.Contains('optional') }) | ForEach-Object {
                    @{ name = $_.name;  allowance = 'optional' }
                }

                $Global:Properties.$Class | Where-Object { !$_.options.Contains('delete_m') -and !$_.options.Contains('delete_o') -and !$_.options.Contains('optional') -and !$_.options.Contains('key') }  | ForEach-Object {
                    @{ name = $_.name; allowance = 'prohibited' }
                }
            )
        }
    }
    else {
        #
        # Execute function
        #
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams

        $uri = "v1/courses/{0}" -f $function_params.id

        $splat = @{
            SystemParams = $system_params
            Method = "DELETE"
            Uri = $uri                    
            Body = ($function_params | ConvertTo-Json)
        }

        Execute-Request @splat

    }

    Log info "Done"
}

function Idm-SectionsDelete {
    param (
        # Operations
        [switch] $GetMeta,
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams
    )

    Log info "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"
    $Class = 'Sections'

    if ($GetMeta) {
        #
        # Get meta data
        #
        @{
            semantics = 'delete'
            parameters = @(
                ($Global:Properties.$Class | Where-Object { $_.options.Contains('delete_m') -or $_.options -contains 'key'}) | ForEach-Object {
                    @{ name = $_.name;  allowance = 'mandatory' }
                }

                ($Global:Properties.$Class | Where-Object { $_.options.Contains('delete_o') -or $_.options.Contains('optional') }) | ForEach-Object {
                    @{ name = $_.name;  allowance = 'optional' }
                }

                $Global:Properties.$Class | Where-Object { !$_.options.Contains('delete_m') -and !$_.options.Contains('delete_o') -and !$_.options.Contains('optional') -and !$_.options.Contains('key') }  | ForEach-Object {
                    @{ name = $_.name; allowance = 'prohibited' }
                }
            )
        }
    }
    else {
        #
        # Execute function
        #
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams

        $uri = ("v1/sections/{0}" -f $function_params.id)

        $splat = @{
            SystemParams = $system_params
            Method = "DELETE"
            Uri = $uri                    
            Body = ($function_params | ConvertTo-Json)
        }

        Execute-Request @splat

    }

    Log info "Done"
}


function Idm-GroupEnrollmentsDelete {
    param (
        # Operations
        [switch] $GetMeta,
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams
    )

    Log info "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"
    $Class = 'GroupEnrollments'

    if ($GetMeta) {
        #
        # Get meta data
        #
        @{
            semantics = 'delete'

            parameters = @(
                ($Global:Properties.$Class | Where-Object {  $_.options.Contains('delete_m') }) | ForEach-Object {
                    @{ name = $_.name;  allowance = 'mandatory' }
                }

                ($Global:Properties.$Class | Where-Object {  $_.options.Contains('delete_o') -or $_.options.Contains('optional') }) | ForEach-Object {
                    @{ name = $_.name;  allowance = 'optional' }
                }

                $Global:Properties.$Class | Where-Object { !$_.options.Contains('delete_o') -and !$_.options.Contains('delete_m') -and !$_.options.Contains('optional') }  | ForEach-Object {
                    @{ name = $_.name; allowance = 'prohibited' }
                }
            )
        }
    }
    else {
        #
        # Execute function
        #
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams


        $splat = @{
            SystemParams = $system_params
            Method = "GET"
            ResponseProperty = 'enrollment'
            Uri = ("v1/groups/{0}/enrollments" -f $function_params.group_id)
        }

        $enrollmentsResponse = Execute-Request @splat

        $targetRow = $enrollmentsResponse | Where-Object { $_.uid -eq $function_params.uid }

        $uri = "v1/groups/{0}/enrollments/{1}" -f $function_params.group_id, $targetRow.id

        $splat = @{
            SystemParams = $system_params
            Method = "DELETE"
            Uri = $uri
        }
        
        Execute-Request @splat

    }

    Log info "Done"
}

function Idm-SectionEnrollmentsDelete {
    param (
        # Operations
        [switch] $GetMeta,
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams
    )

    Log info "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"
    $Class = 'SectionEnrollments'

    if ($GetMeta) {
        #
        # Get meta data
        #
        @{
            semantics = 'delete'
            parameters = @(
                ($Global:Properties.$Class | Where-Object { $_.options.Contains('delete_m') -or $_.options -contains 'key'}) | ForEach-Object {
                    @{ name = $_.name;  allowance = 'mandatory' }
                }

                ($Global:Properties.$Class | Where-Object { $_.options.Contains('delete_o') -or $_.options.Contains('optional') }) | ForEach-Object {
                    @{ name = $_.name;  allowance = 'optional' }
                }

                $Global:Properties.$Class | Where-Object { !$_.options.Contains('delete_m') -and !$_.options.Contains('delete_o') -and !$_.options.Contains('optional') -and !$_.options.Contains('key') }  | ForEach-Object {
                    @{ name = $_.name; allowance = 'prohibited' }
                }
            )
        }
    }
    else {
        #
        # Execute function
        #
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams

        $splat = @{
            SystemParams = $system_params
            Method = "GET"
            ResponseProperty = 'enrollment'
            Uri = ("v1/sections/{0}/enrollments" -f $function_params.section_id)
        }

        $enrollmentsResponse = Execute-Request @splat

        $targetRow = $enrollmentsResponse | Where-Object { $_.uid -eq $function_params.uid }

        $uri = "v1/sections/{0}/enrollments/{1}" -f $function_params.section_id, $targetRow.id

        $splat = @{
            SystemParams = $system_params
            Method = "DELETE"
            Uri = $uri
        }
        
        Execute-Request @splat

    }

    Log info "Done"
}
#Delete Functions End

#Membership Functions




#
#   Internal Functions
#
function Initialize-Proxy {
    param (
        [hashtable] $SystemParams
    )

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
                    
        $Global:Proxy['ProxyAddress'] = $SystemParams.proxy_address

        if($SystemParams.use_proxy_credentials)
        {
            $Global:Proxy["ProxyCredential"] = New-Object System.Management.Automation.PSCredential ($SystemParams.proxy_username, (ConvertTo-SecureString $SystemParams.proxy_password -AsPlainText -Force) )
        }
    } else {
        $Global:Proxy = $null
    }


}


function Execute-Authorization {
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

    $Global:AuthToken = $Authorization   

}

function Execute-Request {
    param (
        [hashtable] $SystemParams,
        [string] $Method,
        [string] $Body,
        [string] $Uri,
        [string] $ResponseProperty,
        [string] $LogMessage,
        [boolean] $LoggingEnabled = $true
    )
    
    if (-not $Global:ProxyInitialized) {
        Initialize-Proxy -SystemParams $SystemParams
        $Global:ProxyInitialized = $true
    }

    if ($Global:AuthToken.length -lt 1) {
        Execute-Authorization $SystemParams
    }

    $splat = @{
        Headers = @{
            "Authorization" = $Global:AuthToken
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
            limit = 50
        }
    }

     if ($SystemParams.use_proxy) {
        $splat["Proxy"] = $Global:Proxy['ProxyAddress']
        if ($SystemParams.use_proxy_credentials) {
            $splat["ProxyCredential"] = $Global:Proxy["ProxyCredential"]
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
                        if($LoggingEnabled) { Log verbose "$($splat.Method) Call: $($splat.Uri)?$queryParams$attemptSuffix" }
                    }
                    else {
                        if($LoggingEnabled) { Log verbose "$($splat.Method) Call: $($splat.Uri)$attemptSuffix" }
                    }
                    
                    Execute-Authorization $SystemParams

                    $splat.Headers = @{
                            "Authorization" = $Global:AuthToken
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
                Write-Host $_.Exception.Response.StatusCode.value__
                if ($statusCode -eq 503) {
                    if ($null -ne $Global:CancellationSource) {
                        $Global:CancellationSource.Cancel()
                    }
                    throw "503 Service Unavailable - Cancelling all requests. - $($_)"
                }

                if ($statusCode -eq 429 -or $statusCode -eq 401 -or $statusCode -eq 500) {
                    $attempt++
                    if ($attempt -ge $SystemParams.nr_of_retries) {
                        throw "Max retry attempts reached for $Uri"
                    }
                    if($LoggingEnabled) { Log warning "Received $statusCode. Retrying in $retryDelay seconds..." }
                    Start-Sleep -Seconds $retryDelay
                    $retryDelay *= 2
                } else {
                    throw $_
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

$configScenarios = @'
[{"name":"Default Configuration","description":"","version":"1.0","createTime":1781800141099,"modify
Time":1781800141099,"name_values":[{"name":"clientKey","value":null},{"name":"clientSecret","value":
null},{"name":"collections","value":["Courses","GradingPeriods","GroupEnrollments","GroupEvents","Gr
oups","Roles","Schools","SectionEnrollments","Sections","Users"]},{"name":"nr_of_retries","value":nu
ll},{"name":"nr_of_sessions","value":null},{"name":"nr_of_threads","value":null},{"name":"proxy_addr
ess","value":null},{"name":"proxy_password","value":null},{"name":"proxy_username","value":null},{"n
ame":"retryDelay","value":null},{"name":"sessions_idle_timeout","value":null},{"name":"use_proxy","v
alue":null},{"name":"use_proxy_credentials","value":null}],"collections":[{"col_name":"Courses","fie
lds":[{"field_name":"id","field_type":"string","include":true,"field_format":"","field_source":"data
","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"title","field_t
ype":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"r
eference":false,"ref_col_fields":[]},{"field_name":"course_code","field_type":"string","include":tru
e,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fi
elds":[]},{"field_name":"department","field_type":"string","include":true,"field_format":"","field_s
ource":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"des
cription","field_type":"string","include":true,"field_format":"","field_source":"data","javascript":
"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"credits","field_type":"string"
,"include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":fal
se,"ref_col_fields":[]},{"field_name":"subject_area","field_type":"string","include":true,"field_for
mat":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"
field_name":"building_id","field_type":"string","include":true,"field_format":"","field_source":"dat
a","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"grade_level_ra
nge_start","field_type":"string","include":true,"field_format":"","field_source":"data","javascript"
:"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"grade_level_range_end","field
_type":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],
"reference":false,"ref_col_fields":[]}],"key":"id","display":"title","name_values":[],"sys_nn":[],"c
ontainer":"","source":"data"},{"col_name":"GradingPeriods","fields":[{"field_name":"id","field_type"
:"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"refer
ence":false,"ref_col_fields":[]},{"field_name":"title","field_type":"string","include":true,"field_f
ormat":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},
{"field_name":"start","field_type":"string","include":true,"field_format":"","field_source":"data","
javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"end","field_type":
"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"refere
nce":false,"ref_col_fields":[]},{"field_name":"active","field_type":"string","include":true,"field_f
ormat":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]}]
,"key":"id","display":"title","name_values":[],"sys_nn":[],"container":"","source":"data"},{"col_nam
e":"GroupEnrollments","fields":[{"field_name":"id","field_type":"string","include":true,"field_forma
t":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"fi
eld_name":"uid","field_type":"string","include":true,"field_format":"","field_source":"data","javasc
ript":"","ref_col":["Users"],"reference":false,"ref_col_fields":[]},{"field_name":"group_id","field_
type":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":["Gr
oups"],"reference":false,"ref_col_fields":[]},{"field_name":"admin","field_type":"string","include":
true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col
_fields":[]},{"field_name":"school_uid","field_type":"string","include":true,"field_format":"","fiel
d_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"
name_title","field_type":"string","include":true,"field_format":"","field_source":"data","javascript
":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"name_title_show","field_type
":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"refe
rence":false,"ref_col_fields":[]},{"field_name":"name_first","field_type":"string","include":true,"f
ield_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields
":[]},{"field_name":"name_first_preferred","field_type":"string","include":true,"field_format":"","f
ield_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name
":"name_middle","field_type":"string","include":true,"field_format":"","field_source":"data","javasc
ript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"name_last","field_type":
"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"refere
nce":false,"ref_col_fields":[]},{"field_name":"name_display","field_type":"string","include":true,"f
ield_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields
":[]},{"field_name":"status","field_type":"string","include":true,"field_format":"","field_source":"
data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]}],"key":"id","display":"gro
up_id","name_values":[],"sys_nn":[],"container":"","source":"data"},{"col_name":"GroupEvents","field
s":[{"field_name":"id","field_type":"string","include":true,"field_format":"","field_source":"data",
"javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"title","field_typ
e":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"ref
erence":false,"ref_col_fields":[]},{"field_name":"description","field_type":"string","include":true,
"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fiel
ds":[]},{"field_name":"start","field_type":"string","include":true,"field_format":"","field_source":
"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"has_end","
field_type":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_col
":[],"reference":false,"ref_col_fields":[]},{"field_name":"end","field_type":"string","include":true
,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fie
lds":[]},{"field_name":"all_day","field_type":"string","include":true,"field_format":"","field_sourc
e":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"editabl
e","field_type":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref
_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"rsvp","field_type":"string","include"
:true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_co
l_fields":[]},{"field_name":"comments_enabled","field_type":"string","include":true,"field_format":"
","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_
name":"type","field_type":"string","include":true,"field_format":"","field_source":"data","javascrip
t":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"realm","field_type":"string
","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":fa
lse,"ref_col_fields":[]},{"field_name":"group_id","field_type":"string","include":true,"field_format
":"","field_source":"data","javascript":"","ref_col":["Groups"],"reference":false,"ref_col_fields":[
]}],"key":"id","display":"title","name_values":[],"sys_nn":[],"container":"","source":"data"},{"col_
name":"Groups","fields":[{"field_name":"id","field_type":"string","include":true,"field_format":"","
field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_nam
e":"title","field_type":"string","include":true,"field_format":"","field_source":"data","javascript"
:"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"description","field_type":"st
ring","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference
":false,"ref_col_fields":[]},{"field_name":"website","field_type":"string","include":true,"field_for
mat":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"
field_name":"access_code","field_type":"string","include":true,"field_format":"","field_source":"dat
a","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"category","fie
ld_type":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[
],"reference":false,"ref_col_fields":[]},{"field_name":"options","field_type":"string","include":tru
e,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fi
elds":[]},{"field_name":"group_code","field_type":"string","include":true,"field_format":"","field_s
ource":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"pri
vacy_level","field_type":"string","include":true,"field_format":"","field_source":"data","javascript
":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"picture_url","field_type":"s
tring","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"referenc
e":false,"ref_col_fields":[]},{"field_name":"school_id","field_type":"string","include":true,"field_
format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]}
,{"field_name":"building_id","field_type":"string","include":true,"field_format":"","field_source":"
data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]}],"key":"id","display":"tit
le","name_values":[],"sys_nn":[],"container":"","source":"data"},{"col_name":"Roles","fields":[{"fie
ld_name":"id","field_type":"string","include":true,"field_format":"","field_source":"data","javascri
pt":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"title","field_type":"strin
g","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":f
alse,"ref_col_fields":[]},{"field_name":"faculty","field_type":"string","include":true,"field_format
":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"fie
ld_name":"role_type","field_type":"string","include":true,"field_format":"","field_source":"data","j
avascript":"","ref_col":[],"reference":false,"ref_col_fields":[]}],"key":"id","display":"title","nam
e_values":[],"sys_nn":[],"container":"","source":"data"},{"col_name":"Schools","fields":[{"field_nam
e":"id","field_type":"string","include":true,"field_format":"","field_source":"data","javascript":""
,"ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"title","field_type":"string","in
clude":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"
ref_col_fields":[]},{"field_name":"address1","field_type":"string","include":true,"field_format":"",
"field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_na
me":"address2","field_type":"string","include":true,"field_format":"","field_source":"data","javascr
ipt":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"city","field_type":"strin
g","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":f
alse,"ref_col_fields":[]},{"field_name":"state","field_type":"string","include":true,"field_format":
"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field
_name":"postal_code","field_type":"string","include":true,"field_format":"","field_source":"data","j
avascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"country","field_typ
e":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"ref
erence":false,"ref_col_fields":[]},{"field_name":"website","field_type":"string","include":true,"fie
ld_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":
[]},{"field_name":"phone","field_type":"string","include":true,"field_format":"","field_source":"dat
a","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"fax","field_ty
pe":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"re
ference":false,"ref_col_fields":[]},{"field_name":"building_code","field_type":"string","include":tr
ue,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_f
ields":[]},{"field_name":"picture_url","field_type":"string","include":true,"field_format":"","field
_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]}],"key":"id","dis
play":"title","name_values":[],"sys_nn":[],"container":"","source":"data"},{"col_name":"SectionEnrol
lments","fields":[{"field_name":"id","field_type":"string","include":true,"field_format":"","field_s
ource":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"uid
","field_type":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_
col":["Users"],"reference":false,"ref_col_fields":[]},{"field_name":"section_id","field_type":"strin
g","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":["Sections"],"re
ference":false,"ref_col_fields":[]},{"field_name":"admin","field_type":"string","include":true,"fiel
d_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[
]},{"field_name":"school_uid","field_type":"string","include":true,"field_format":"","field_source":
"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"name_title
","field_type":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_
col":[],"reference":false,"ref_col_fields":[]},{"field_name":"name_title_show","field_type":"string"
,"include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":fal
se,"ref_col_fields":[]},{"field_name":"name_first","field_type":"string","include":true,"field_forma
t":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"fi
eld_name":"name_first_preferred","field_type":"string","include":true,"field_format":"","field_sourc
e":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"name_mi
ddle","field_type":"string","include":true,"field_format":"","field_source":"data","javascript":"","
ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"name_last","field_type":"string","
include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false
,"ref_col_fields":[]},{"field_name":"name_display","field_type":"string","include":true,"field_forma
t":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"fi
eld_name":"status","field_type":"string","include":true,"field_format":"","field_source":"data","jav
ascript":"","ref_col":[],"reference":false,"ref_col_fields":[]}],"key":"id","display":"section_id","
name_values":[],"sys_nn":[],"container":"","source":"data"},{"col_name":"Sections","fields":[{"field
_name":"id","field_type":"string","include":true,"field_format":"","field_source":"data","javascript
":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"course_title","field_type":"
string","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"referen
ce":false,"ref_col_fields":[]},{"field_name":"course_code","field_type":"string","include":true,"fie
ld_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":
[]},{"field_name":"course_id","field_type":"string","include":true,"field_format":"","field_source":
"data","javascript":"","ref_col":["Courses"],"reference":false,"ref_col_fields":[]},{"field_name":"s
chool_id","field_type":"string","include":true,"field_format":"","field_source":"data","javascript":
"","ref_col":["Schools"],"reference":false,"ref_col_fields":[]},{"field_name":"access_code","field_t
ype":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"r
eference":false,"ref_col_fields":[]},{"field_name":"section_title","field_type":"string","include":t
rue,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_
fields":[]},{"field_name":"section_code","field_type":"string","include":true,"field_format":"","fie
ld_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":
"section_school_code","field_type":"string","include":true,"field_format":"","field_source":"data","
javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"active","field_typ
e":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"ref
erence":false,"ref_col_fields":[]},{"field_name":"grading_periods","field_type":"string","include":t
rue,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_
fields":[]},{"field_name":"description","field_type":"string","include":true,"field_format":"","fiel
d_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"
location","field_type":"string","include":true,"field_format":"","field_source":"data","javascript":
"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"meeting_days","field_type":"st
ring","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference
":false,"ref_col_fields":[]},{"field_name":"start_time","field_type":"string","include":true,"field_
format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]}
,{"field_name":"end_time","field_type":"string","include":true,"field_format":"","field_source":"dat
a","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"weight","field
_type":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],
"reference":false,"ref_col_fields":[]},{"field_name":"admin","field_type":"string","include":true,"f
ield_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields
":[]}],"key":"id","display":"section_title","name_values":[],"sys_nn":[],"container":"section_title"
,"source":"data"},{"col_name":"Users","fields":[{"field_name":"uid","field_type":"string","include":
true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col
_fields":[]},{"field_name":"id","field_type":"string","include":true,"field_format":"","field_source
":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"school_i
d","field_type":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref
_col":["Schools"],"reference":false,"ref_col_fields":[]},{"field_name":"synced","field_type":"string
","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":fa
lse,"ref_col_fields":[]},{"field_name":"school_uid","field_type":"string","include":true,"field_form
at":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"f
ield_name":"name_title","field_type":"string","include":true,"field_format":"","field_source":"data"
,"javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"name_title_show"
,"field_type":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_c
ol":[],"reference":false,"ref_col_fields":[]},{"field_name":"name_first","field_type":"string","incl
ude":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"re
f_col_fields":[]},{"field_name":"name_first_preferred","field_type":"string","include":true,"field_f
ormat":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},
{"field_name":"use_preferred_first_name","field_type":"string","include":true,"field_format":"","fie
ld_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":
"name_middle","field_type":"string","include":true,"field_format":"","field_source":"data","javascri
pt":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"name_middle_show","field_t
ype":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"r
eference":false,"ref_col_fields":[]},{"field_name":"name_last","field_type":"string","include":true,
"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fiel
ds":[]},{"field_name":"name_display","field_type":"string","include":true,"field_format":"","field_s
ource":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"use
rname","field_type":"string","include":true,"field_format":"","field_source":"data","javascript":"",
"ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"primary_email","field_type":"stri
ng","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":
false,"ref_col_fields":[]},{"field_name":"gender","field_type":"string","include":true,"field_format
":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"fie
ld_name":"position","field_type":"string","include":true,"field_format":"","field_source":"data","ja
vascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"grad_year","field_ty
pe":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"re
ference":false,"ref_col_fields":[]},{"field_name":"password","field_type":"string","include":true,"f
ield_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields
":[]},{"field_name":"role_id","field_type":"string","include":true,"field_format":"","field_source":
"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"parents","
field_type":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_col
":[],"reference":false,"ref_col_fields":[]},{"field_name":"parent_uids","field_type":"string","inclu
de":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref
_col_fields":[]},{"field_name":"child_uids","field_type":"string","include":true,"field_format":"","
field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_nam
e":"language","field_type":"string","include":true,"field_format":"","field_source":"data","javascri
pt":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"additional_buildings","fie
ld_type":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[
],"reference":false,"ref_col_fields":[]},{"field_name":"parent_access_code","field_type":"string","i
nclude":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,
"ref_col_fields":[]},{"field_name":"option_comment","field_type":"string","include":true,"field_form
at":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"f
ield_name":"option_keep_enrollments","field_type":"string","include":true,"field_format":"","field_s
ource":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"ema
il_notification","field_type":"string","include":true,"field_format":"","field_source":"data","javas
cript":"","ref_col":[],"reference":false,"ref_col_fields":[]}],"key":"uid","display":"name_display",
"name_values":[],"sys_nn":[],"container":"","source":"data"}]}]
'@
