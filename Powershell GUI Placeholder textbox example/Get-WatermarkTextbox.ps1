#Load required libraries
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Windows.Forms, System.Drawing 

[xml]$xaml = @"
<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:WpfApplication2"

        Title="PlaceHolder Text Demo" Height="141" Width="300" Topmost="True">
    <Grid>
        <TextBox x:Name="FirstName" HorizontalAlignment="Left" Height="23" Margin="10,10,0,0" TextWrapping="Wrap" Text="Type valid First Name" VerticalAlignment="Top" Width="200" Foreground="DarkGray" />
        <TextBox x:Name="LastName" HorizontalAlignment="Left" Height="23" Margin="10,38,0,0" TextWrapping="Wrap" Text="Type valid Last Name" VerticalAlignment="Top" Width="200" Foreground="DarkGray"/>
        <TextBox x:Name="Contry" HorizontalAlignment="Left" Height="23" Margin="10,66,0,0" TextWrapping="Wrap" Text="Type valid contry" VerticalAlignment="Top" Width="200" Foreground="DarkGray"/>

    </Grid>
</Window>

"@

#Read the form
$Reader = (New-Object System.Xml.XmlNodeReader $xaml) 
$Form = [Windows.Markup.XamlReader]::Load($reader) 

#AutoFind all controls
$xaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]")  | ForEach-Object { 
  New-Variable  -Name $_.Name -Value $Form.FindName($_.Name) -Force 
}

#Textbox placeholder remove default text when textbox clicked
$FirstName.Add_GotFocus({
    
    if ($FirstName.Text -eq 'Type valid First Name') {
        $FirstName.Foreground = 'Black'
        $FirstName.Text = ''
    }
})
#Textbox placeholder grayed out text when textbox clicked
$FirstName.Add_LostFocus({
    if ($FirstName.Text -eq '') {
        $FirstName.Text = 'Type valid First Name'
        $FirstName.Foreground = 'Darkgray'
    }
})

#Textbox placeholder remove default text when textbox clicked
$LastName.Add_GotFocus({
    
    if ($LastName.Text -eq 'Type valid Last Name') {
        $LastName.Foreground = 'Black'
        $LastName.Text = ''
    }
})
#Textbox placeholder grayed out text when textbox clicked
$LastName.Add_LostFocus({
    if ($LastName.Text -eq '') {
        $LastName.Text = 'Type valid Last Name'
        $LastName.Foreground = 'Darkgray'
    }
})

#Textbox placeholder remove default text when textbox clicked
$Contry.Add_GotFocus({
    
    if ($Contry.Text -eq 'Type valid contry') {
        $Contry.Foreground = 'Black'
        $Contry.Text = ''
    }
})
#Textbox placeholder grayed out text when textbox clicked
$Contry.Add_LostFocus({
    if ($Contry.Text -eq '') {
        $Contry.Text = 'Type valid contry'
        $Contry.Foreground = 'Darkgray'
    }
})

#Mandetory last line of every script to load form
$Form.ShowDialog()