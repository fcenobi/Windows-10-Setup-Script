﻿Add-Type -AssemblyName "PresentationCore", "PresentationFramework", "WindowsBase"

[xml]$xamlMarkup = @'
<Window
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        Name="Window" Title="Windows 10 Setup Script" MinHeight="760" MinWidth="1165" Height="760" Width="1165"
        FontFamily="Calibri" FontSize="14" TextOptions.TextFormattingMode="Display" WindowStartupLocation="CenterScreen"
        SnapsToDevicePixels="True" ResizeMode="CanResize"
        ShowInTaskbar="True" Background="{DynamicResource {x:Static SystemColors.WindowBrushKey}}"
        Foreground="{DynamicResource {x:Static SystemColors.WindowTextBrushKey}}">
    <Window.Resources>

    <Storyboard x:Key="StoryboardHamburgerMenu" x:Name="StoryboardHamburgerMenu">
    <DoubleAnimation Storyboard.TargetName="HamburgerMenu" Storyboard.TargetProperty="Width" Duration="0:0:1" SpeedRatio="3" To="200" />
        </Storyboard>

        <Style x:Key="GridHamburgerButton" TargetType="Grid">
            <Setter Property="HorizontalAlignment" Value="Left"/>
            <Setter Property="VerticalAlignment" Value="Center"/>
            <Setter Property="Height" Value="50"/>
            <Setter Property="Width" Value="50"/>
            <Style.Triggers>
                <Trigger  Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="#2196F3"/>
                </Trigger>
                <Trigger  Property="IsMouseOver" Value="False">
                    <Setter Property="Background" Value="#3F51B5"/>
                </Trigger>
            </Style.Triggers>
        </Style>

        <Style x:Key="PanelHamburgerMenu" TargetType="StackPanel">
            <Setter Property="Orientation" Value="Horizontal"/>
            <Setter Property="Width" Value="{Binding ElementName=HamburgerMenu, Path=Width}"/>
            <Style.Triggers>
                <Trigger  Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="#2196F3"/>
                </Trigger>
                <Trigger  Property="IsMouseOver" Value="False">
                    <Setter Property="Background" Value="#3F51B5"/>
                </Trigger>
            </Style.Triggers>
        </Style>

        <Style x:Key="TextblockHamburgerMenu" TargetType="TextBlock">
            <Setter Property="VerticalAlignment" Value="Center"/>
            <Setter Property="Foreground" Value="#FFFFFF"/>
            <Setter Property="FontSize" Value="16"/>
            <Setter Property="Margin" Value="5 0 5 0"/>
            <Setter Property="Opacity" Value="0.5"/>
        </Style>

        <Style x:Key="ViewboxFooter" TargetType="{x:Type Viewbox}">
            <Setter Property="Width" Value="22"/>
            <Setter Property="Height" Value="22"/>
            <Setter Property="VerticalAlignment" Value="Center"/>
            <Setter Property="HorizontalAlignment" Value="Center"/>
            <Setter Property="Margin" Value="5 0 5 0"/>
        </Style>

        <Style x:Key="PanelFooterButtons" TargetType="StackPanel">
            <Setter Property="Orientation" Value="Horizontal"/>
            <Setter Property="VerticalAlignment" Value="Center"/>
            <Setter Property="HorizontalAlignment" Value="Center"/>
            <Style.Triggers>
                <EventTrigger RoutedEvent="MouseDown">
                    <EventTrigger.Actions>
                        <BeginStoryboard>
                            <Storyboard>
                                <ThicknessAnimation  Storyboard.TargetProperty="Margin" Duration="0:0:1" From="0 0 0 0" To="0 0 0 -5" SpeedRatio="5" AutoReverse="True" />
                            </Storyboard>
                        </BeginStoryboard>
                    </EventTrigger.Actions>
                </EventTrigger>
            </Style.Triggers>
        </Style>


    </Window.Resources>

    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="50"/>
            <RowDefinition Height="*"/>
            <!--<RowDefinition Height="30"/>-->
        </Grid.RowDefinitions>

        <!--#region Title Panel-->
        <Grid Grid.Row="0" Background="#E4E4E4">

            <!--#region Hamburger Button-->
            <Grid Name="ButtonHamburger" Style="{StaticResource GridHamburgerButton}">
                <Viewbox Width="28" Height="28" VerticalAlignment="Center" HorizontalAlignment="Center">
                    <Canvas Width="24" Height="24">
                        <Path Data="M3,6H21V8H3V6M3,11H21V13H3V11M3,16H21V18H3V16Z" Fill="#FFFFFF" />
                    </Canvas>
                </Viewbox>
            </Grid>
            <!--#endregion Hamburger Button-->

            <!--#region Category Text-->
            <TextBlock Name="TextblockCategory" Text="Privacy &amp; Telemetry" FontSize="18" VerticalAlignment="Center" HorizontalAlignment="Left" Margin="55 0 0 3" />
            <!--#endregion Category Text-->

        </Grid>
        <!--#endregion Title Panel-->

        <!--#region Body Panel-->
        <StackPanel Grid.Row="1" Orientation="Horizontal">

            <!--#region Hamburger Panel-->
            <Canvas Name="HamburgerMenu" Width="50" Background="#3F51B5">

                <!--#region Privacy & Telemetry Button-->
                <StackPanel Name="Button_Privacy" Style="{StaticResource PanelHamburgerMenu}">
                    <StackPanel.Triggers>
                        <EventTrigger RoutedEvent="MouseDown">
                            <EventTrigger.Actions>
                                <BeginStoryboard>
                                    <Storyboard>
                                        <ThicknessAnimation Storyboard.TargetName="Viewbox_Privacy" Storyboard.TargetProperty="Margin" Duration="0:0:1" From="10 10 10 10" To="10 15 10 10" SpeedRatio="5" AutoReverse="True" />
                                        <ThicknessAnimation Storyboard.TargetName="Textblock_Privacy" Storyboard.TargetProperty="Margin" Duration="0:0:1" From="5 0 5 0" To="5 5 5 0" SpeedRatio="5" AutoReverse="True" />
                                    </Storyboard>
                                </BeginStoryboard>
                            </EventTrigger.Actions>
                        </EventTrigger>
                    </StackPanel.Triggers>
                    <Viewbox Name="Viewbox_Privacy" Width="28" Height="28" VerticalAlignment="Center" HorizontalAlignment="Left" Margin="10">
                        <Canvas Width="24" Height="24">
                            <Path Data="M18,20V10H6V20H18M18,8A2,2 0 0,1 20,10V20A2,2 0 0,1 18,22H6C4.89,22 4,21.1 4,20V10A2,2 0 0,1 6,8H15V6A3,3 0 0,0 12,3A3,3 0 0,0 9,6H7A5,5 0 0,1 12,1A5,5 0 0,1 17,6V8H18M12,17A2,2 0 0,1 10,15A2,2 0 0,1 12,13A2,2 0 0,1 14,15A2,2 0 0,1 12,17Z"
                                  Fill="#FFFFFF">
                                <Path.Style>
                                    <Style TargetType="Path">
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Button_Privacy, Path=IsMouseOver}" Value="True">
                                                <Setter Property="Opacity" Value="1"/>
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Button_Privacy, Path=IsMouseOver}" Value="False">
                                                <Setter Property="Opacity" Value="0.5"/>
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </Path.Style>
                            </Path>
                        </Canvas>
                    </Viewbox>
                    <TextBlock Name="Textblock_Privacy" Text="Privacy &amp; Telemetry" >
                        <TextBlock.Style>
                            <Style TargetType="TextBlock">
                                <Setter Property="VerticalAlignment" Value="Center"/>
                                <Setter Property="Foreground" Value="#FFFFFF"/>
                                <Setter Property="FontSize" Value="16"/>
                                <Setter Property="Margin" Value="5 0 5 0"/>
                                <Style.Triggers>
                                    <DataTrigger Binding="{Binding ElementName=Button_Privacy, Path=IsMouseOver}" Value="True">
                                        <Setter Property="Opacity" Value="1"/>
                                    </DataTrigger>
                                    <DataTrigger Binding="{Binding ElementName=Button_Privacy, Path=IsMouseOver}" Value="False">
                                        <Setter Property="Opacity" Value="0.5"/>
                                    </DataTrigger>
                                </Style.Triggers>
                            </Style>
                        </TextBlock.Style>
                    </TextBlock>
                </StackPanel>
                <!--#endregion Privacy & Telemetry Button-->


            </Canvas>
            <!--#endregion Hamburger Panel-->
        </StackPanel>

        <!--#endregion Body Panel-->

        <!--#region Footer Panel--><!--
        <Grid Grid.Row="1" VerticalAlignment="Bottom" Background="#E4E4E4" Height="30">

        --><!--#region Follow on GitHub Button--><!--
        <StackPanel Orientation="Horizontal">
            <StackPanel.Style>
                <Style TargetType="StackPanel">
                    <Style.Triggers>
                        <EventTrigger RoutedEvent="MouseDown">
                            <EventTrigger.Actions>
                                <BeginStoryboard>
                                    <Storyboard>
                                        <ThicknessAnimation  Storyboard.TargetProperty="Margin" Duration="0:0:1" From="0 0 0 0" To="0 0 0 -5" SpeedRatio="5" AutoReverse="True" />
                                    </Storyboard>
                                </BeginStoryboard>
                            </EventTrigger.Actions>
                        </EventTrigger>
                    </Style.Triggers>
                </Style>
            </StackPanel.Style>
            <Viewbox Style="{StaticResource ViewboxFooter}" >
                <Canvas Width="24" Height="24">
                    <Path Data="M12,2A10,10 0 0,0 2,12C2,16.42 4.87,20.17 8.84,21.5C9.34,21.58 9.5,21.27 9.5,21C9.5,20.77 9.5,20.14 9.5,19.31C6.73,19.91 6.14,17.97 6.14,17.97C5.68,16.81 5.03,16.5 5.03,16.5C4.12,15.88 5.1,15.9 5.1,15.9C6.1,15.97 6.63,16.93 6.63,16.93C7.5,18.45 8.97,18 9.54,17.76C9.63,17.11 9.89,16.67 10.17,16.42C7.95,16.17 5.62,15.31 5.62,11.5C5.62,10.39 6,9.5 6.65,8.79C6.55,8.54 6.2,7.5 6.75,6.15C6.75,6.15 7.59,5.88 9.5,7.17C10.29,6.95 11.15,6.84 12,6.84C12.85,6.84 13.71,6.95 14.5,7.17C16.41,5.88 17.25,6.15 17.25,6.15C17.8,7.5 17.45,8.54 17.35,8.79C18,9.5 18.38,10.39 18.38,11.5C18.38,15.32 16.04,16.16 13.81,16.41C14.17,16.72 14.5,17.33 14.5,18.26C14.5,19.6 14.5,20.68 14.5,21C14.5,21.27 14.66,21.59 15.17,21.5C19.14,20.16 22,16.42 22,12A10,10 0 0,0 12,2Z" Fill="#FFFFFF" />
                </Canvas>
            </Viewbox>
            <TextBlock Name="TextBlock_GitHub" VerticalAlignment="Center" Padding="5 3 5 3">
                <TextBlock.Style>
                    <Style TargetType="{x:Type TextBlock}">
                        <Style.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter Property="Text" Value="https://github.com/farag2/Windows-10-Setup-Script"/>
                                <Setter Property="TextDecorations" Value="Underline"/>
                                <Setter Property="Cursor" Value="Hand"/>
                            </Trigger>
                            <Trigger Property="IsMouseOver" Value="False">
                                <Setter Property="Text" Value="Follow on GitHub"/>
                            </Trigger>
                        </Style.Triggers>
                    </Style>
                </TextBlock.Style>
            </TextBlock>
        </StackPanel>

        --><!--#endregion Follow on GitHub Button-->

        <!--#region Change Language Button--><!--

        <StackPanel Name="ButtonChangeLanguage" Style="{StaticResource PanelFooterButtons}" HorizontalAlignment="Right">
            <TextBlock Foreground="#FFFFFF" VerticalAlignment="Center"
                           Padding="10 3 14 3">
                <TextBlock.Style>
                    <Style TargetType="{x:Type TextBlock}">
                        <Style.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter Property="Text" Value="RU"/>
                                <Setter Property="Cursor" Value="Hand"/>
                            </Trigger>
                            <Trigger Property="IsMouseOver" Value="False">
                                <Setter Property="Text" Value="EN"/>
                            </Trigger>
                        </Style.Triggers>
                    </Style>
                </TextBlock.Style>
            </TextBlock>

        </StackPanel>
        </Grid>

        --><!--#endregion Change Language Button-->

        <!--#endregion Footer Panel-->
    </Grid>

</Window>
'@

$xamlGui = [System.Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $xamlMarkup))
$xamlMarkup.SelectNodes('//*[@Name]') | ForEach-Object {
    New-Variable -Name $_.Name -Value $xamlGui.FindName($_.Name)

}

#region Script Functions
function Hide-Console {
    <#
    .SYNOPSIS
    Hide Powershell console before show WPF GUI.
    #>

    [CmdletBinding()]
    param ()

    Add-Type -Name Window -Namespace Console -MemberDefinition '
    [DllImport("Kernel32.dll")]
    public static extern IntPtr GetConsoleWindow();

    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'
    [Console.Window]::ShowWindow([Console.Window]::GetConsoleWindow(), 0)
}

function Update-HamburgerMenu {
    <#
    .SYNOPSIS
    Show or hide hamburger menu.
    #>

    [CmdletBinding()]
    param ()

    $minWidth = 50
    $maxWidth = 200
    $duration = New-Object System.Windows.Duration([timespan]::FromSeconds(1))
	$widthProperty = New-Object System.Windows.PropertyPath([System.Windows.Controls.Canvas]::WidthProperty)

    if ($HamburgerMenu.ActualWidth -eq $minWidth) {
        $animation = New-Object System.Windows.Media.Animation.DoubleAnimation($minWidth, $maxWidth, $duration)
    }

    else {
        $animation = New-Object System.Windows.Media.Animation.DoubleAnimation($maxWidth, $minWidth, $duration)
    }

    $animation.SpeedRatio ="3"
	$storyboard = New-Object System.Windows.Media.Animation.Storyboard
	[System.Windows.Media.Animation.Storyboard]::SetTargetProperty($animation, $widthProperty)
    $storyboard.Children.Add($animation)
    $storyboard.Begin($HamburgerMenu)
}

# function Join-ToGithub {
#     <#
#     .SYNOPSIS
#     Open "https://github.com/farag2/Windows-10-Setup-Script" in default browser.
#     #>
#     [CmdletBinding()]
#     param ()

#     Start-Process -FilePath "explorer.exe" -ArgumentList "https://github.com/farag2/Windows-10-Setup-Script"
# }

#endregion

#region Controls Events
$Window.Add_MouseLeftButtonDown({
    $Window.DragMove()
})

$ButtonHamburger.Add_MouseLeftButtonDown({
    Update-HamburgerMenu
})





#endregion

Hide-Console
$Window.ShowDialog() | Out-Null