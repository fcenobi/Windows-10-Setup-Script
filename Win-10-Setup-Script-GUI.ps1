﻿Add-Type -AssemblyName "PresentationCore", "PresentationFramework", "WindowsBase"

#region Script Variables
$ToggleButtons = New-Object System.Collections.ArrayList($null)
#endregion

[xml]$xamlMarkup = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"                        
        x:Name="Window"
        Title="Windows 10 Setup Script" MinHeight="800" MinWidth="800" Height="800" Width="800" FontFamily="Sergio UI"
        FontSize="16" TextOptions.TextFormattingMode="Display" WindowStartupLocation="CenterScreen" 
        SnapsToDevicePixels="True" WindowStyle="None" ResizeMode="CanResizeWithGrip" AllowsTransparency="True" 
        ShowInTaskbar="True">
    <Window.Resources>

        <!--#region Brushes -->

        <SolidColorBrush x:Key="RadioButton.Static.Background" Color="#FFFFFFFF"/>
        <SolidColorBrush x:Key="RadioButton.Static.Border" Color="#FF333333"/>
        <SolidColorBrush x:Key="RadioButton.Static.Glyph" Color="#FF333333"/>

        <SolidColorBrush x:Key="RadioButton.MouseOver.Background" Color="#FFFFFFFF"/>
        <SolidColorBrush x:Key="RadioButton.MouseOver.Border" Color="#FF000000"/>
        <SolidColorBrush x:Key="RadioButton.MouseOver.Glyph" Color="#FF000000"/>

        <SolidColorBrush x:Key="RadioButton.MouseOver.On.Background" Color="#FF4C91C8"/>
        <SolidColorBrush x:Key="RadioButton.MouseOver.On.Border" Color="#FF4C91C8"/>
        <SolidColorBrush x:Key="RadioButton.MouseOver.On.Glyph" Color="#FFFFFFFF"/>

        <SolidColorBrush x:Key="RadioButton.Disabled.Background" Color="#FFFFFFFF"/>
        <SolidColorBrush x:Key="RadioButton.Disabled.Border" Color="#FF999999"/>
        <SolidColorBrush x:Key="RadioButton.Disabled.Glyph" Color="#FF999999"/>

        <SolidColorBrush x:Key="RadioButton.Disabled.On.Background" Color="#FFCCCCCC"/>
        <SolidColorBrush x:Key="RadioButton.Disabled.On.Border" Color="#FFCCCCCC"/>
        <SolidColorBrush x:Key="RadioButton.Disabled.On.Glyph" Color="#FFA3A3A3"/>

        <SolidColorBrush x:Key="RadioButton.Pressed.Background" Color="#FF999999"/>
        <SolidColorBrush x:Key="RadioButton.Pressed.Border" Color="#FF999999"/>
        <SolidColorBrush x:Key="RadioButton.Pressed.Glyph" Color="#FFFFFFFF"/>

        <SolidColorBrush x:Key="RadioButton.Checked.Background" Color="#FF0063B1"/>
        <SolidColorBrush x:Key="RadioButton.Checked.Border" Color="#FF0063B1"/>
        <SolidColorBrush x:Key="RadioButton.Checked.Glyph" Color="#FFFFFFFF"/>

        <!--#endregion-->

        <Style x:Key="ToggleSwitchTopStyle" TargetType="{x:Type ToggleButton}">
            <Setter Property="Background" Value="{StaticResource RadioButton.Static.Background}"/>
            <Setter Property="BorderBrush" Value="{StaticResource RadioButton.Static.Border}"/>
            <Setter Property="Foreground" Value="{DynamicResource {x:Static SystemColors.ControlTextBrushKey}}"/>
            <Setter Property="HorizontalContentAlignment" Value="Left"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="SnapsToDevicePixels" Value="True"/>
            <Setter Property="FocusVisualStyle" Value="{x:Null}"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="{x:Type ToggleButton}">
                        <Grid x:Name="templateRoot" 
							  Background="Transparent" 
							  SnapsToDevicePixels="{TemplateBinding SnapsToDevicePixels}">
                            <VisualStateManager.VisualStateGroups>
                                <VisualStateGroup x:Name="CommonStates">
                                    <VisualState x:Name="Normal"/>
                                    <VisualState x:Name="MouseOver">
                                        <Storyboard>
                                            <DoubleAnimation To="0" Duration="0:0:0.2" Storyboard.TargetName="normalBorder" Storyboard.TargetProperty="(UIElement.Opacity)"/>
                                            <DoubleAnimation To="1" Duration="0:0:0.2" Storyboard.TargetName="hoverBorder" Storyboard.TargetProperty="(UIElement.Opacity)"/>
                                            <ObjectAnimationUsingKeyFrames Storyboard.TargetName="optionMark" Storyboard.TargetProperty="Fill" Duration="0:0:0.2">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.MouseOver.Glyph}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <ObjectAnimationUsingKeyFrames Storyboard.TargetName="optionMarkOn" Storyboard.TargetProperty="Fill" Duration="0:0:0.2">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.MouseOver.On.Glyph}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                        </Storyboard>
                                    </VisualState>
                                    <VisualState x:Name="Pressed">
                                        <Storyboard>
                                            <DoubleAnimation To="1" Duration="0" Storyboard.TargetName="pressedBorder" Storyboard.TargetProperty="(UIElement.Opacity)"/>
                                            <ObjectAnimationUsingKeyFrames Storyboard.TargetName="optionMark" Storyboard.TargetProperty="Fill" Duration="0">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Pressed.Glyph}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                        </Storyboard>
                                    </VisualState>
                                    <VisualState x:Name="Disabled">
                                        <Storyboard>
                                            <ObjectAnimationUsingKeyFrames Duration="0" Storyboard.TargetName="checkedBorder" Storyboard.TargetProperty="BorderBrush">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Disabled.On.Border}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <ObjectAnimationUsingKeyFrames Duration="0" Storyboard.TargetName="checkedBorder" Storyboard.TargetProperty="Background">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Disabled.On.Background}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <DoubleAnimation To="1" Duration="0" Storyboard.TargetName="disabledBorder" Storyboard.TargetProperty="(UIElement.Opacity)"/>
                                            <ObjectAnimationUsingKeyFrames Storyboard.TargetName="optionMark" Storyboard.TargetProperty="Fill" Duration="0">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Disabled.Glyph}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <ObjectAnimationUsingKeyFrames Storyboard.TargetName="optionMarkOn" Storyboard.TargetProperty="Fill" Duration="0">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Disabled.On.Glyph}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                        </Storyboard>
                                    </VisualState>
                                </VisualStateGroup>
                                <VisualStateGroup x:Name="CheckStates">
                                    <VisualState x:Name="Unchecked"/>
                                    <VisualState x:Name="Checked">
                                        <Storyboard>
                                            <ObjectAnimationUsingKeyFrames Storyboard.TargetName="optionMark" Storyboard.TargetProperty="Fill" Duration="0">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Static.Glyph}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <DoubleAnimationUsingKeyFrames Duration="0:0:0.5" Storyboard.TargetProperty="(UIElement.RenderTransform).(TransformGroup.Children)[3].(TranslateTransform.X)" Storyboard.TargetName="optionMark">
                                                <EasingDoubleKeyFrame KeyTime="0" Value="12"/>
                                            </DoubleAnimationUsingKeyFrames>
                                            <ObjectAnimationUsingKeyFrames Duration="0" Storyboard.TargetName="optionMark" Storyboard.TargetProperty="Fill">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Checked.Glyph}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <ObjectAnimationUsingKeyFrames Duration="0" Storyboard.TargetName="hoverBorder" Storyboard.TargetProperty="BorderBrush">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.MouseOver.On.Border}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <ObjectAnimationUsingKeyFrames Duration="0" Storyboard.TargetName="hoverBorder" Storyboard.TargetProperty="Background">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.MouseOver.On.Background}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <DoubleAnimation To="1" Duration="0" Storyboard.TargetName="optionMarkOn" Storyboard.TargetProperty="(UIElement.Opacity)"/>
                                            <DoubleAnimation To="1" Duration="0" Storyboard.TargetName="checkedBorder" Storyboard.TargetProperty="(UIElement.Opacity)"/>
                                            <ObjectAnimationUsingKeyFrames Duration="0" Storyboard.TargetName="disabledBorder" Storyboard.TargetProperty="BorderBrush">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Disabled.On.Border}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <ObjectAnimationUsingKeyFrames Duration="0" Storyboard.TargetName="disabledBorder" Storyboard.TargetProperty="Background">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Disabled.On.Background}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                        </Storyboard>
                                    </VisualState>
                                    <VisualState x:Name="Indeterminate"/>
                                </VisualStateGroup>
                                <VisualStateGroup x:Name="FocusStates">
                                    <VisualState x:Name="Unfocused"/>
                                    <VisualState x:Name="Focused"/>
                                </VisualStateGroup>
                            </VisualStateManager.VisualStateGroups>
                            <Grid.RowDefinitions>
                                <RowDefinition />
                                <RowDefinition Height="Auto"/>
                            </Grid.RowDefinitions>
                            <ContentPresenter x:Name="contentPresenter" 
											  Focusable="False" RecognizesAccessKey="True" 
											  HorizontalAlignment="{TemplateBinding HorizontalContentAlignment}" 
											  Margin="{TemplateBinding Padding}" 
											  SnapsToDevicePixels="{TemplateBinding SnapsToDevicePixels}" 
											  VerticalAlignment="{TemplateBinding VerticalContentAlignment}"/>
                            <Grid x:Name="markGrid" Grid.Row="1" Margin="10 0 10 0" Width="44" Height="20"
								  HorizontalAlignment="{TemplateBinding HorizontalContentAlignment}">
                                <Border x:Name="normalBorder" Opacity="1" BorderThickness="2" CornerRadius="10"
										BorderBrush="{TemplateBinding BorderBrush}" Background="{StaticResource RadioButton.Static.Background}"/>
                                <Border x:Name="checkedBorder" Opacity="0" BorderThickness="2" CornerRadius="10"
										BorderBrush="{StaticResource  RadioButton.Checked.Border}" Background="{StaticResource RadioButton.Checked.Background}"/>
                                <Border x:Name="hoverBorder" Opacity="0" BorderThickness="2" CornerRadius="10"
										BorderBrush="{StaticResource RadioButton.MouseOver.Border}" Background="{StaticResource RadioButton.MouseOver.Background}"/>
                                <Border x:Name="pressedBorder" Opacity="0" BorderThickness="2" CornerRadius="10"
										BorderBrush="{StaticResource RadioButton.Pressed.Border}" Background="{StaticResource RadioButton.Pressed.Background}"/>
                                <Border x:Name="disabledBorder" Opacity="0" BorderThickness="2" CornerRadius="10"
										BorderBrush="{StaticResource RadioButton.Disabled.Border}" Background="{StaticResource RadioButton.Disabled.Background}"/>
                                <Ellipse x:Name="optionMark"
										 Height="10" Width="10" Fill="{StaticResource RadioButton.Static.Glyph}" StrokeThickness="0" 
										 VerticalAlignment="Center" Margin="5,0" RenderTransformOrigin="0.5,0.5">
                                    <Ellipse.RenderTransform>
                                        <TransformGroup>
                                            <ScaleTransform/>
                                            <SkewTransform/>
                                            <RotateTransform/>
                                            <TranslateTransform X="-12"/>
                                        </TransformGroup>
                                    </Ellipse.RenderTransform>
                                </Ellipse>
                                <Ellipse x:Name="optionMarkOn" Opacity="0"
										 Height="10" Width="10" Fill="{StaticResource RadioButton.Checked.Glyph}" StrokeThickness="0" 
										 VerticalAlignment="Center" Margin="5,0" RenderTransformOrigin="0.5,0.5">
                                    <Ellipse.RenderTransform>
                                        <TransformGroup>
                                            <ScaleTransform/>
                                            <SkewTransform/>
                                            <RotateTransform/>
                                            <TranslateTransform X="12"/>
                                        </TransformGroup>
                                    </Ellipse.RenderTransform>
                                </Ellipse>
                            </Grid>
                        </Grid>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style x:Key="ToggleSwitchLeftStyle" TargetType="{x:Type ToggleButton}">
            <Setter Property="Background" Value="{StaticResource RadioButton.Static.Background}"/>
            <Setter Property="BorderBrush" Value="{StaticResource RadioButton.Static.Border}"/>
            <Setter Property="Foreground" Value="{DynamicResource {x:Static SystemColors.ControlTextBrushKey}}"/>
            <Setter Property="HorizontalContentAlignment" Value="Left"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="SnapsToDevicePixels" Value="True"/>
            <Setter Property="FocusVisualStyle" Value="{x:Null}"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="{x:Type ToggleButton}">
                        <Grid x:Name="templateRoot" 
							  Background="Transparent" 
							  SnapsToDevicePixels="{TemplateBinding SnapsToDevicePixels}">
                            <VisualStateManager.VisualStateGroups>
                                <VisualStateGroup x:Name="CommonStates">
                                    <VisualState x:Name="Normal"/>
                                    <VisualState x:Name="MouseOver">
                                        <Storyboard>
                                            <DoubleAnimation To="0" Duration="0:0:0.2" Storyboard.TargetName="normalBorder" Storyboard.TargetProperty="(UIElement.Opacity)"/>
                                            <DoubleAnimation To="1" Duration="0:0:0.2" Storyboard.TargetName="hoverBorder" Storyboard.TargetProperty="(UIElement.Opacity)"/>
                                            <ObjectAnimationUsingKeyFrames Storyboard.TargetName="optionMark" Storyboard.TargetProperty="Fill" Duration="0:0:0.2">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.MouseOver.Glyph}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <ObjectAnimationUsingKeyFrames Storyboard.TargetName="optionMarkOn" Storyboard.TargetProperty="Fill" Duration="0:0:0.2">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.MouseOver.On.Glyph}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                        </Storyboard>
                                    </VisualState>
                                    <VisualState x:Name="Pressed">
                                        <Storyboard>
                                            <DoubleAnimation To="1" Duration="0" Storyboard.TargetName="pressedBorder" Storyboard.TargetProperty="(UIElement.Opacity)"/>
                                            <ObjectAnimationUsingKeyFrames Storyboard.TargetName="optionMark" Storyboard.TargetProperty="Fill" Duration="0">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Pressed.Glyph}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                        </Storyboard>
                                    </VisualState>
                                    <VisualState x:Name="Disabled">
                                        <Storyboard>
                                            <ObjectAnimationUsingKeyFrames Duration="0" Storyboard.TargetName="checkedBorder" Storyboard.TargetProperty="BorderBrush">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Disabled.On.Border}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <ObjectAnimationUsingKeyFrames Duration="0" Storyboard.TargetName="checkedBorder" Storyboard.TargetProperty="Background">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Disabled.On.Background}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <DoubleAnimation To="1" Duration="0" Storyboard.TargetName="disabledBorder" Storyboard.TargetProperty="(UIElement.Opacity)"/>
                                            <ObjectAnimationUsingKeyFrames Storyboard.TargetName="optionMark" Storyboard.TargetProperty="Fill" Duration="0">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Disabled.Glyph}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <ObjectAnimationUsingKeyFrames Storyboard.TargetName="optionMarkOn" Storyboard.TargetProperty="Fill" Duration="0">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Disabled.On.Glyph}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                        </Storyboard>
                                    </VisualState>
                                </VisualStateGroup>
                                <VisualStateGroup x:Name="CheckStates">
                                    <VisualState x:Name="Unchecked"/>
                                    <VisualState x:Name="Checked">
                                        <Storyboard>
                                            <ObjectAnimationUsingKeyFrames Storyboard.TargetName="optionMark" Storyboard.TargetProperty="Fill" Duration="0">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Static.Glyph}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <DoubleAnimationUsingKeyFrames Duration="0:0:0.5" Storyboard.TargetProperty="(UIElement.RenderTransform).(TransformGroup.Children)[3].(TranslateTransform.X)" Storyboard.TargetName="optionMark">
                                                <EasingDoubleKeyFrame KeyTime="0" Value="12"/>
                                            </DoubleAnimationUsingKeyFrames>
                                            <ObjectAnimationUsingKeyFrames Duration="0" Storyboard.TargetName="optionMark" Storyboard.TargetProperty="Fill">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Checked.Glyph}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <ObjectAnimationUsingKeyFrames Duration="0" Storyboard.TargetName="hoverBorder" Storyboard.TargetProperty="BorderBrush">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.MouseOver.On.Border}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <ObjectAnimationUsingKeyFrames Duration="0" Storyboard.TargetName="hoverBorder" Storyboard.TargetProperty="Background">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.MouseOver.On.Background}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <DoubleAnimation To="1" Duration="0" Storyboard.TargetName="optionMarkOn" Storyboard.TargetProperty="(UIElement.Opacity)"/>
                                            <DoubleAnimation To="1" Duration="0" Storyboard.TargetName="checkedBorder" Storyboard.TargetProperty="(UIElement.Opacity)"/>
                                            <ObjectAnimationUsingKeyFrames Duration="0" Storyboard.TargetName="disabledBorder" Storyboard.TargetProperty="BorderBrush">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Disabled.On.Border}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <ObjectAnimationUsingKeyFrames Duration="0" Storyboard.TargetName="disabledBorder" Storyboard.TargetProperty="Background">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Disabled.On.Background}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                        </Storyboard>
                                    </VisualState>
                                    <VisualState x:Name="Indeterminate"/>
                                </VisualStateGroup>
                                <VisualStateGroup x:Name="FocusStates">
                                    <VisualState x:Name="Unfocused"/>
                                    <VisualState x:Name="Focused"/>
                                </VisualStateGroup>
                            </VisualStateManager.VisualStateGroups>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition />
                                <ColumnDefinition Width="Auto"/>
                            </Grid.ColumnDefinitions>
                            <ContentPresenter x:Name="contentPresenter" 
											  Focusable="False" RecognizesAccessKey="True" 
											  HorizontalAlignment="{TemplateBinding HorizontalContentAlignment}" 
											  Margin="{TemplateBinding Padding}" 
											  SnapsToDevicePixels="{TemplateBinding SnapsToDevicePixels}" 
											  VerticalAlignment="{TemplateBinding VerticalContentAlignment}"/>
                            <Grid x:Name="markGrid" Grid.Column="1" Margin="8 0 0 0" Width="44" Height="20"
                                  VerticalAlignment="Center"
								  HorizontalAlignment="{TemplateBinding HorizontalContentAlignment}">
                                <Border x:Name="normalBorder" Opacity="1" BorderThickness="2" CornerRadius="10"
										BorderBrush="{TemplateBinding BorderBrush}" Background="{StaticResource RadioButton.Static.Background}"/>
                                <Border x:Name="checkedBorder" Opacity="0" BorderThickness="2" CornerRadius="10"
										BorderBrush="{StaticResource  RadioButton.Checked.Border}" Background="{StaticResource RadioButton.Checked.Background}"/>
                                <Border x:Name="hoverBorder" Opacity="0" BorderThickness="2" CornerRadius="10"
										BorderBrush="{StaticResource RadioButton.MouseOver.Border}" Background="{StaticResource RadioButton.MouseOver.Background}"/>
                                <Border x:Name="pressedBorder" Opacity="0" BorderThickness="2" CornerRadius="10"
										BorderBrush="{StaticResource RadioButton.Pressed.Border}" Background="{StaticResource RadioButton.Pressed.Background}"/>
                                <Border x:Name="disabledBorder" Opacity="0" BorderThickness="2" CornerRadius="10"
										BorderBrush="{StaticResource RadioButton.Disabled.Border}" Background="{StaticResource RadioButton.Disabled.Background}"/>
                                <Ellipse x:Name="optionMark"
										 Height="10" Width="10" Fill="{StaticResource RadioButton.Static.Glyph}" StrokeThickness="0" 
										 VerticalAlignment="Center" Margin="5,0" RenderTransformOrigin="0.5,0.5">
                                    <Ellipse.RenderTransform>
                                        <TransformGroup>
                                            <ScaleTransform/>
                                            <SkewTransform/>
                                            <RotateTransform/>
                                            <TranslateTransform X="-12"/>
                                        </TransformGroup>
                                    </Ellipse.RenderTransform>
                                </Ellipse>
                                <Ellipse x:Name="optionMarkOn" Opacity="0"
										 Height="10" Width="10" Fill="{StaticResource RadioButton.Checked.Glyph}" StrokeThickness="0" 
										 VerticalAlignment="Center" Margin="5,0" RenderTransformOrigin="0.5,0.5">
                                    <Ellipse.RenderTransform>
                                        <TransformGroup>
                                            <ScaleTransform/>
                                            <SkewTransform/>
                                            <RotateTransform/>
                                            <TranslateTransform X="12"/>
                                        </TransformGroup>
                                    </Ellipse.RenderTransform>
                                </Ellipse>
                            </Grid>
                        </Grid>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style x:Key="TextBlockStyle" TargetType="{x:Type TextBlock}">
            <Setter Property="FontFamily" Value="Segoe UI"/>
            <Setter Property="TextOptions.TextFormattingMode" Value="Display"/>
        </Style>

        <Style x:Key="ItemTitleStyle" TargetType="{x:Type TextBlock}" BasedOn="{StaticResource TextBlockStyle}">
            <Setter Property="Margin" Value="1"/>
            <Setter Property="FontSize" Value="16"/>
        </Style>

        <Style x:Key="ItemSubTitleStyle" TargetType="{x:Type TextBlock}" BasedOn="{StaticResource ItemTitleStyle}">
            <Style.Triggers>
                <DataTrigger Binding="{Binding RelativeSource={RelativeSource AncestorType=ToggleButton}, Path=IsChecked}" Value="True">
                    <Setter Property="Text" Value="On: Banners, Sound"/>
                    <Setter Property="Foreground" Value="{DynamicResource {x:Static SystemColors.GrayTextBrushKey}}"/>
                </DataTrigger>
                <DataTrigger Binding="{Binding RelativeSource={RelativeSource AncestorType=ToggleButton}, Path=IsChecked}" Value="False">
                    <Setter Property="Text" Value="Off"/>
                    <Setter Property="Foreground" Value="{DynamicResource {x:Static SystemColors.GrayTextBrushKey}}"/>
                </DataTrigger>
            </Style.Triggers>
        </Style>

        <SolidColorBrush x:Key="Hover.Enter.Brush" Color="#FFF2F2F2" />
        <SolidColorBrush x:Key="Hover.Exit.Brush" Color="#01FFFFFF" />

        <Storyboard x:Key="Hover.Enter.Storyboard">
            <ObjectAnimationUsingKeyFrames Storyboard.TargetProperty="Background">
                <DiscreteObjectKeyFrame KeyTime="0:0:0" Value="{StaticResource Hover.Enter.Brush}" />
            </ObjectAnimationUsingKeyFrames>
        </Storyboard>

        <Storyboard x:Key="Hover.Exit.Storyboard">
            <ObjectAnimationUsingKeyFrames Storyboard.TargetProperty="Background">
                <DiscreteObjectKeyFrame KeyTime="0:0:0" Value="{StaticResource Hover.Exit.Brush}" />
            </ObjectAnimationUsingKeyFrames>
        </Storyboard>

        <Style x:Key="HoverBorder" TargetType="Border">
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Margin" Value="0 4"/>
            <Setter Property="Padding" Value="10 2"/>
            <Style.Triggers>
                <EventTrigger RoutedEvent="Mouse.MouseEnter">
                    <BeginStoryboard Storyboard="{StaticResource Hover.Enter.Storyboard}" />
                </EventTrigger>
                <EventTrigger RoutedEvent="Mouse.MouseLeave">
                    <BeginStoryboard Storyboard="{StaticResource Hover.Exit.Storyboard}" />
                </EventTrigger>
            </Style.Triggers>
        </Style>

        <Style x:Key="IconBorder" TargetType="Border">
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Margin" Value="0 0 10 0"/>
            <Setter Property="Padding" Value="4"/>
            <Setter Property="Width" Value="40"/>
            <Setter Property="Height" Value="40"/>
            <Setter Property="Background" Value="{StaticResource RadioButton.Checked.Background}"/>
        </Style>

        <Style x:Key="CanvasTitleButton" TargetType="Canvas">
            <Setter Property="Height" Value="35"/>
            <Setter Property="Width" Value="35"/>
            <Style.Triggers>
                <Trigger Property="Canvas.IsMouseOver" Value="True">
                    <Setter Property="Canvas.Background" Value="#DA1F2E"/>
                    <Setter Property="Canvas.Opacity" Value="5"/>
                </Trigger>
            </Style.Triggers>
        </Style>

    </Window.Resources>

    <Border x:Name="BorderWindow" BorderThickness="1" BorderBrush="#0078D7">
        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="35"/>
                <RowDefinition Height="*"/>
                <RowDefinition Height="35"/>
            </Grid.RowDefinitions>
            <!--#region Title Panel-->
            <Canvas Grid.Row="0" Background="{Binding ElementName=BorderWindow, Path=BorderBrush}">
                <!--Title Icons-->
                <Viewbox Width="24" Height="24" Canvas.Left="10" Canvas.Top="5">
                    <Path Data="M3,12V6.75L9,5.43V11.91L3,12M20,3V11.75L10,11.9V5.21L20,3M3,13L9,13.09V19.9L3,18.75V13M20,13.25V22L10,20.09V13.1L20,13.25Z" Fill="{Binding ElementName=TitleHeader, Path=Foreground}" />
                </Viewbox>
                <!--Title Header-->
                <TextBlock x:Name="TitleHeader" Text="{Binding ElementName=Window, Path=Title}" FontFamily="Sergio UI" FontSize="14" Canvas.Left="44" Canvas.Top="10" Foreground="#FFFFFF"/>
                <!--Title Minimize Button-->
                <Canvas Name="MinimizeButton" Canvas.Right="35" Canvas.Top="0" Style="{DynamicResource CanvasTitleButton}">
                    <Viewbox Width="24" Height="24" Canvas.Left="4">
                        <Path  Data="M20,14H4V10H20" Fill="{Binding ElementName=TitleHeader,Path=Foreground}" />
                    </Viewbox>
                </Canvas>
                <!--Title Close Button-->
                <Canvas Name="CloseButton" Canvas.Right="0" Canvas.Top="0" Style="{DynamicResource CanvasTitleButton}">
                    <Viewbox Width="24" Height="24" Canvas.Left="4" Canvas.Top="2">
                        <Path Data="M19,6.41L17.59,5L12,10.59L6.41,5L5,6.41L10.59,12L5,17.59L6.41,19L12,13.41L17.59,19L19,17.59L13.41,12L19,6.41Z" Fill="{Binding ElementName=TitleHeader,Path=Foreground}" />
                    </Viewbox>
                </Canvas>
            </Canvas>
            <!--#endregion Title Panel-->
            
            <!--#region Control Panel-->
            <StackPanel Grid.Row="1" Orientation="Vertical" Width="200" Height="200" VerticalAlignment="Top" 
                        HorizontalAlignment="Right" Margin="10 30 10 0" Panel.ZIndex="10">
                
            </StackPanel>
            <!--#endregion Control Panel-->

            <!--#region Setting Panel-->
            <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto" HorizontalScrollBarVisibility="Disabled">
                <StackPanel Orientation="Vertical">
                    <!--#region Privacy & Telemetry-->
                    <StackPanel Orientation="Horizontal" Height="35" Margin="0 5 0 0">
                        <Viewbox Width="24" Height="24" Margin="20 0 5 6" >
                            <Path Data="M12 5.69L17 10.19V18H15V12H9V18H7V10.19L12 5.69M12 3L2 12H5V20H11V14H13V20H19V12H22L12 3Z" Fill="Black" />
                        </Viewbox>
                        <TextBlock Text="Privacy &amp; Telemetry" VerticalAlignment="Center" FontWeight="Bold"/>
                    </StackPanel>
                    
                    <StackPanel Orientation="Horizontal" Margin="0 2 0 2">
                        <Grid Margin="0" HorizontalAlignment="Left">
                            <ToggleButton Name="ToggleButton0" FontFamily="Sergio UI" FontSize="1"
                          Style="{DynamicResource ToggleSwitchTopStyle}" Content="" IsChecked="False"/>
                            <TextBlock Name="TextBlock0" Margin="65 3 0 0" VerticalAlignment="Center" FontFamily="Sergio UI" FontSize="16">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock" BasedOn="{StaticResource TextBlockStyle}">
                                        <Setter Property="Text" Value="Turn off &quot;Connected User Experiences and Telemetry&quot; service" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=ToggleButton0, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="Turn off &quot;Connected User Experiences and Telemetry&quot; service" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=ToggleButton0, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>
                    </StackPanel>
                    
                    <StackPanel Orientation="Horizontal" Margin="0 2 0 2">
                        <Grid Margin="0" HorizontalAlignment="Left">
                            <ToggleButton Name="ToggleButton1" FontFamily="Sergio UI" FontSize="1"
                          Style="{DynamicResource ToggleSwitchTopStyle}" Content="" IsChecked="False"/>
                            <TextBlock Name="TextBlock1" Margin="65 3 0 0" VerticalAlignment="Center" FontFamily="Sergio UI" FontSize="16">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock" BasedOn="{StaticResource TextBlockStyle}">
                                        <Setter Property="Text" Value="Turn off per-user services" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=ToggleButton1, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="Turn off per-user services" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=ToggleButton1, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>
                    </StackPanel>

                    <StackPanel Orientation="Horizontal" Margin="0 2 0 2">
                        <Grid Margin="0" HorizontalAlignment="Left">
                            <ToggleButton Name="ToggleButton2" FontFamily="Sergio UI" FontSize="1"
                          Style="{DynamicResource ToggleSwitchTopStyle}" Content="" IsChecked="False"/>
                            <TextBlock Name="TextBlock2" Margin="65 3 0 0" VerticalAlignment="Center" FontFamily="Sergio UI" FontSize="16">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock" BasedOn="{StaticResource TextBlockStyle}">
                                        <Setter Property="Text" Value="Turn off the Autologger session at the next computer restart" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=ToggleButton2, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="Turn off the Autologger session at the next computer restart" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=ToggleButton2, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>
                    </StackPanel>

                    <StackPanel Orientation="Horizontal" Margin="0 2 0 2">
                        <Grid Margin="0" HorizontalAlignment="Left">
                            <ToggleButton Name="ToggleButton3" FontFamily="Sergio UI" FontSize="1"
                          Style="{DynamicResource ToggleSwitchTopStyle}" Content="" IsChecked="False"/>
                            <TextBlock Name="TextBlock3" Margin="65 3 0 0" VerticalAlignment="Center" FontFamily="Sergio UI" FontSize="16">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock" BasedOn="{StaticResource TextBlockStyle}">
                                        <Setter Property="Text" Value="Turn off the SQMLogger session at the next computer restart" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=ToggleButton3, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="Turn off the SQMLogger session at the next computer restart" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=ToggleButton3, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>
                    </StackPanel>

                    <StackPanel Orientation="Horizontal" Margin="0 2 0 2">
                        <Grid Margin="0" HorizontalAlignment="Left">
                            <ToggleButton Name="ToggleButton4" FontFamily="Sergio UI" FontSize="1"
                          Style="{DynamicResource ToggleSwitchTopStyle}" Content="" IsChecked="False"/>
                            <TextBlock Name="TextBlock4" Margin="65 3 0 0" VerticalAlignment="Center" FontFamily="Sergio UI" FontSize="16">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock" BasedOn="{StaticResource TextBlockStyle}">
                                        <Setter Property="Text" Value="Set the operating system diagnostic data level to &quot;Basic&quot;" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=ToggleButton4, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="Set the operating system diagnostic data level to &quot;Basic&quot;" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=ToggleButton4, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>
                    </StackPanel>

                    <StackPanel Orientation="Horizontal" Margin="0 2 0 2">
                        <Grid Margin="0" HorizontalAlignment="Left">
                            <ToggleButton Name="ToggleButton5" FontFamily="Sergio UI" FontSize="1"
                          Style="{DynamicResource ToggleSwitchTopStyle}" Content="" IsChecked="False"/>
                            <TextBlock Name="TextBlock5" Margin="65 3 0 0" VerticalAlignment="Center" FontFamily="Sergio UI" FontSize="16">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock" BasedOn="{StaticResource TextBlockStyle}">
                                        <Setter Property="Text" Value="Turn off Windows Error Reporting" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=ToggleButton5, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="Turn off Windows Error Reporting" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=ToggleButton5, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>
                    </StackPanel>

                    <StackPanel Orientation="Horizontal" Margin="0 2 0 2">
                        <Grid Margin="0" HorizontalAlignment="Left">
                            <ToggleButton Name="ToggleButton6" FontFamily="Sergio UI" FontSize="1"
                          Style="{DynamicResource ToggleSwitchTopStyle}" Content="" IsChecked="False"/>
                            <TextBlock Name="TextBlock6" Margin="65 3 0 0" VerticalAlignment="Center" FontFamily="Sergio UI" FontSize="16">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock" BasedOn="{StaticResource TextBlockStyle}">
                                        <Setter Property="Text" Value="Change Windows Feedback frequency to &quot;Never&quot;" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=ToggleButton6, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="Change Windows Feedback frequency to &quot;Never&quot;" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=ToggleButton6, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>
                    </StackPanel>

                    <StackPanel Orientation="Horizontal" Margin="0 2 0 2">
                        <Grid Margin="0" HorizontalAlignment="Left">
                            <ToggleButton Name="ToggleButton7" FontFamily="Sergio UI" FontSize="1"
                          Style="{DynamicResource ToggleSwitchTopStyle}" Content="" IsChecked="False"/>
                            <TextBlock Name="TextBlock7" Margin="65 3 0 0" VerticalAlignment="Center" FontFamily="Sergio UI" FontSize="16">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock" BasedOn="{StaticResource TextBlockStyle}">
                                        <Setter Property="Text" Value="Turn off diagnostics tracking scheduled tasks" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=ToggleButton7, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="Turn off diagnostics tracking scheduled tasks" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=ToggleButton7, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>
                    </StackPanel>

                    <StackPanel Orientation="Horizontal" Margin="0 2 0 2">
                        <Grid Margin="0" HorizontalAlignment="Left">
                            <ToggleButton Name="ToggleButton8" FontFamily="Sergio UI" FontSize="1"
                          Style="{DynamicResource ToggleSwitchTopStyle}" Content="" IsChecked="False"/>
                            <TextBlock Name="TextBlock8" Margin="65 3 0 0" VerticalAlignment="Center" FontFamily="Sergio UI" FontSize="16">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock" BasedOn="{StaticResource TextBlockStyle}">
                                        <Setter Property="Text" Value="Do not offer tailored experiences based on the diagnostic data setting" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=ToggleButton8, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="Do not offer tailored experiences based on the diagnostic data setting" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=ToggleButton8, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>
                    </StackPanel>

                    <StackPanel Orientation="Horizontal" Margin="0 2 0 2">
                        <Grid Margin="0" HorizontalAlignment="Left">
                            <ToggleButton Name="ToggleButton9" FontFamily="Sergio UI" FontSize="1"
                          Style="{DynamicResource ToggleSwitchTopStyle}" Content="" IsChecked="False"/>
                            <TextBlock Name="TextBlock9" Margin="65 3 0 0" VerticalAlignment="Center" FontFamily="Sergio UI" FontSize="16">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock" BasedOn="{StaticResource TextBlockStyle}">
                                        <Setter Property="Text" Value="Do not let apps on other devices open and message apps on this device" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=ToggleButton9, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="Do not let apps on other devices open and message apps on this device" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=ToggleButton9, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>
                    </StackPanel>

                    <StackPanel Orientation="Horizontal" Margin="0 2 0 2">
                        <Grid Margin="0" HorizontalAlignment="Left">
                            <ToggleButton Name="ToggleButton10" FontFamily="Sergio UI" FontSize="1"
                          Style="{DynamicResource ToggleSwitchTopStyle}" Content="" IsChecked="False"/>
                            <TextBlock Name="TextBlock10" Margin="65 3 0 0" VerticalAlignment="Center" FontFamily="Sergio UI" FontSize="16">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock" BasedOn="{StaticResource TextBlockStyle}">
                                        <Setter Property="Text" Value="Do not allow apps to use advertising ID" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=ToggleButton10, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="Do not allow apps to use advertising ID" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=ToggleButton10, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>
                    </StackPanel>

                    <StackPanel Orientation="Horizontal" Margin="0 2 0 2">
                        <Grid Margin="0" HorizontalAlignment="Left">
                            <ToggleButton Name="ToggleButton11" FontFamily="Sergio UI" FontSize="1"
                          Style="{DynamicResource ToggleSwitchTopStyle}" Content="" IsChecked="False"/>
                            <TextBlock Name="TextBlock11" Margin="65 3 0 0" VerticalAlignment="Center" FontFamily="Sergio UI" FontSize="16">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock" BasedOn="{StaticResource TextBlockStyle}">
                                        <Setter Property="Text" Value="Do not use sign-in info to automatically finish setting up device after an update or restart" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=ToggleButton11, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="Do not use sign-in info to automatically finish setting up device after an update or restart" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=ToggleButton11, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>
                    </StackPanel>

                    <StackPanel Orientation="Horizontal" Margin="0 2 0 2">
                        <Grid Margin="0" HorizontalAlignment="Left">
                            <ToggleButton Name="ToggleButton12" FontFamily="Sergio UI" FontSize="1"
                          Style="{DynamicResource ToggleSwitchTopStyle}" Content="" IsChecked="False"/>
                            <TextBlock Name="TextBlock12" Margin="65 3 0 0" VerticalAlignment="Center" FontFamily="Sergio UI" FontSize="16">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock" BasedOn="{StaticResource TextBlockStyle}">
                                        <Setter Property="Text" Value="Do not let websites provide locally relevant content by accessing language list" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=ToggleButton12, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="Do not let websites provide locally relevant content by accessing language list" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=ToggleButton12, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>
                    </StackPanel>

                    <StackPanel Orientation="Horizontal" Margin="0 2 0 2">
                        <Grid Margin="0" HorizontalAlignment="Left">
                            <ToggleButton Name="ToggleButton13" FontFamily="Sergio UI" FontSize="1"
                          Style="{DynamicResource ToggleSwitchTopStyle}" Content="" IsChecked="False"/>
                            <TextBlock Name="TextBlock13" Margin="65 3 0 0" VerticalAlignment="Center" FontFamily="Sergio UI" FontSize="16">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock" BasedOn="{StaticResource TextBlockStyle}">
                                        <Setter Property="Text" Value="Turn off reserved storage" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=ToggleButton13, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="Turn off reserved storage" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=ToggleButton13, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>
                    </StackPanel>

                    <StackPanel Orientation="Horizontal" Margin="0 2 0 2">
                        <Grid Margin="0" HorizontalAlignment="Left">
                            <ToggleButton Name="ToggleButton14" FontFamily="Sergio UI" FontSize="1"
                          Style="{DynamicResource ToggleSwitchTopStyle}" Content="" IsChecked="False"/>
                            <TextBlock Name="TextBlock14" Margin="65 3 0 0" VerticalAlignment="Center" FontFamily="Sergio UI" FontSize="16">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock" BasedOn="{StaticResource TextBlockStyle}">
                                        <Setter Property="Text" Value="Turn off tip, trick, and suggestions as you use Windows" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=ToggleButton14, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="Turn off tip, trick, and suggestions as you use Windows" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=ToggleButton14, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>
                    </StackPanel>

                    <StackPanel Orientation="Horizontal" Margin="0 2 0 2">
                        <Grid Margin="0" HorizontalAlignment="Left">
                            <ToggleButton Name="ToggleButton15" FontFamily="Sergio UI" FontSize="1"
                          Style="{DynamicResource ToggleSwitchTopStyle}" Content="" IsChecked="False"/>
                            <TextBlock Name="TextBlock15" Margin="65 3 0 0" VerticalAlignment="Center" FontFamily="Sergio UI" FontSize="16">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock" BasedOn="{StaticResource TextBlockStyle}">
                                        <Setter Property="Text" Value="Turn off suggested content in the Settings" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=ToggleButton15, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="Turn off suggested content in the Settings" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=ToggleButton15, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>
                    </StackPanel>

                    <StackPanel Orientation="Horizontal" Margin="0 2 0 2">
                        <Grid Margin="0" HorizontalAlignment="Left">
                            <ToggleButton Name="ToggleButton16" FontFamily="Sergio UI" FontSize="1"
                          Style="{DynamicResource ToggleSwitchTopStyle}" Content="" IsChecked="False"/>
                            <TextBlock Name="TextBlock16" Margin="65 3 0 0" VerticalAlignment="Center" FontFamily="Sergio UI" FontSize="16">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock" BasedOn="{StaticResource TextBlockStyle}">
                                        <Setter Property="Text" Value="Turn off automatic installing suggested apps" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=ToggleButton16, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="Turn off automatic installing suggested apps" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=ToggleButton16, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>
                    </StackPanel>
                    <!--#endregion-->
                    
                    <!--#region UI & Personalization-->
                    <StackPanel Orientation="Horizontal" Height="35" Margin="0 5 0 0">
                        <Viewbox Width="24" Height="24" Margin="20 0 5 6" >
                            <Path Data="M12 5.69L17 10.19V18H15V12H9V18H7V10.19L12 5.69M12 3L2 12H5V20H11V14H13V20H19V12H22L12 3Z" Fill="Black" />
                        </Viewbox>
                        <TextBlock Text="UI &amp; Personalization" VerticalAlignment="Center" FontWeight="Bold"/>
                    </StackPanel>

                    <StackPanel Orientation="Horizontal" Margin="0 2 0 2">
                        <Grid Margin="0" HorizontalAlignment="Left">
                            <ToggleButton Name="ToggleButton17" FontFamily="Sergio UI" FontSize="1"
                          Style="{DynamicResource ToggleSwitchTopStyle}" Content="" IsChecked="False"/>
                            <TextBlock Name="TextBlock17" Margin="65 3 0 0" VerticalAlignment="Center" FontFamily="Sergio UI" FontSize="16">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock" BasedOn="{StaticResource TextBlockStyle}">
                                        <Setter Property="Text" Value="Set File Explorer to open to This PC by default" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=ToggleButton17, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="Set File Explorer to open to This PC by default" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=ToggleButton17, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>
                    </StackPanel>

                    <StackPanel Orientation="Horizontal" Margin="0 2 0 2">
                        <Grid Margin="0" HorizontalAlignment="Left">
                            <ToggleButton Name="ToggleButton18" FontFamily="Sergio UI" FontSize="1"
                          Style="{DynamicResource ToggleSwitchTopStyle}" Content="" IsChecked="False"/>
                            <TextBlock Name="TextBlock18" Margin="65 3 0 0" VerticalAlignment="Center" FontFamily="Sergio UI" FontSize="16">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock" BasedOn="{StaticResource TextBlockStyle}">
                                        <Setter Property="Text" Value="Show Hidden Files, Folders, and Drives" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=ToggleButton18, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="Show Hidden Files, Folders, and Drives" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=ToggleButton18, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>
                    </StackPanel>

                    <StackPanel Orientation="Horizontal" Margin="0 2 0 2">
                        <Grid Margin="0" HorizontalAlignment="Left">
                            <ToggleButton Name="ToggleButton19" FontFamily="Sergio UI" FontSize="1"
                          Style="{DynamicResource ToggleSwitchTopStyle}" Content="" IsChecked="False"/>
                            <TextBlock Name="TextBlock19" Margin="65 3 0 0" VerticalAlignment="Center" FontFamily="Sergio UI" FontSize="16">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock" BasedOn="{StaticResource TextBlockStyle}">
                                        <Setter Property="Text" Value="Show File Name Extensions" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=ToggleButton19, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="Show File Name Extensions" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=ToggleButton19, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>
                    </StackPanel>

                    <StackPanel Orientation="Horizontal" Margin="0 2 0 2">
                        <Grid Margin="0" HorizontalAlignment="Left">
                            <ToggleButton Name="ToggleButton20" FontFamily="Sergio UI" FontSize="1"
                          Style="{DynamicResource ToggleSwitchTopStyle}" Content="" IsChecked="False"/>
                            <TextBlock Name="TextBlock20" Margin="65 3 0 0" VerticalAlignment="Center" FontFamily="Sergio UI" FontSize="16">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock" BasedOn="{StaticResource TextBlockStyle}">
                                        <Setter Property="Text" Value="Hide Task View button on taskbar" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=ToggleButton20, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="Hide Task View button on taskbar" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=ToggleButton20, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>
                    </StackPanel>
                </StackPanel>
            </ScrollViewer>
            <!--#endregion Setting Panel-->

            <!--#region Info Panel-->
            <StackPanel Grid.Row="2" Background="{Binding ElementName=BorderWindow, Path=BorderBrush}" Orientation="Horizontal">

            </StackPanel>
            <!--#endregion Info Panel-->

        </Grid>
    </Border>
</Window>
'@

$xamlGui = [System.Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $xamlMarkup))
$xamlMarkup.SelectNodes('//*[@Name]') | ForEach-Object {
    
    if ($_.Name.Contains("ToggleButton")) {

        $ToggleBtn = $xamlGui.FindName($_.Name)
        [Void]$ToggleButtons.Add($ToggleBtn)
    }
	
	else
	{
		New-Variable -Name $_.Name -Value $xamlGui.FindName($_.Name)
	}    
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

#endregion

#region Controls Events

$xamlGui.add_MouseLeftButtonDown( {
        $xamlGui.DragMove()
    })

$MinimizeButton.add_MouseLeftButtonDown( {
        $xamlGui.WindowState = "Minimized"
    })

$CloseButton.add_MouseLeftButtonDown( {
        $xamlGui.Close()
    })

#endregion

Hide-Console
$xamlGui.ShowDialog() | Out-Null