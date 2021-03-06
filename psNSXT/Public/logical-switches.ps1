#
# Copyright 2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-NSXTLogicalSwitches {

    <#
        .SYNOPSIS
        Get information about Logical Switches

        .DESCRIPTION
        Returns information about Logical Switches

        .EXAMPLE
        Get-NSXTLogicalSwitches

        Display all Logical Switches

        .EXAMPLE
        Get-NSXTLogicalSwitches -id 1ff59e9b-8e82-41ae-95bf-28fd737d6023

        Display Logical Switches with id 1ff59e9b-8e82-41ae-95bf-28fd737d6023

        .EXAMPLE
        Get-NSXTLogicalSwitches -switching_profile_id ede3e69a-6562-49a6-98c4-d23408bd832c

        Display Logical Switches with switching_profile_id ede3e69a-6562-49a6-98c4-d23408bd832c

        .EXAMPLE
        Get-NSXTLogicalSwitches -display_name MyLogicalSwitch

        Display Logical Switches with (display) name MyLogicalSwitch

        .EXAMPLE
        Get-NSXTLogicalSwitches -transport_zone_id ede3e69a-6562-49a6-98c4-d23408bd832c

        Display Logical Switches with transport_zone_id ede3e69a-6562-49a6-98c4-d23408bd832c

        .EXAMPLE
        Get-NSXTLogicalSwitches -vlan 23

        Display Logical Switches with vlan 23

    #>

    [CmdletBinding(DefaultParametersetname = "Default")]
    Param(
        [Parameter(Mandatory = $false, ParameterSetName = "id", position = 1)]
        [string]$id,
        [Parameter(Mandatory = $false, ParameterSetName = "Default")]
        [string]$switching_profile_id,
        [Parameter(Mandatory = $false, ParameterSetName = "display_name")]
        [string]$display_name,
        [Parameter(Mandatory = $false, ParameterSetName = "Default")]
        [string]$transport_zone_id,
        [Parameter(Mandatory = $false, ParameterSetName = "Default")]
        [int]$vlan,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultNSXTConnection
    )

    Begin {
    }

    Process {

        $uri = 'api/v1/logical-switches'

        if ( $PsBoundParameters.ContainsKey('id') ) {
            $uri += "/$id"
        }

        $uri += "?"
        if ( $PsBoundParameters.ContainsKey('switching_profile_id') ) {
            $uri += "&switching_profile_id=$switching_profile_id"
        }

        if ( $PsBoundParameters.ContainsKey('transport_zone_id') ) {
            $uri += "&transport_zone_id=$transport_zone_id"
        }

        if ( $PsBoundParameters.ContainsKey('vlan') ) {
            $uri += "&vlan=$vlan"
        }

        $response = Invoke-NSXTRestMethod -uri $uri -method 'GET' -connection $connection

        switch ( $PSCmdlet.ParameterSetName ) {
            "id" {
                #When there is a id, it is directly the result...
                $response
            }
            "display_name" {
                #When there is a display_name, search on response
                $response.results | Where-Object { $_.display_name -eq $display_name }
            }
            default {
                $response.results
            }
        }

    }

    End {
    }
}