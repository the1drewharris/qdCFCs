'
' DotNetNuke® - http://www.dotnetnuke.com
' Copyright (c) 2002-2005
' by Perpetual Motion Interactive Systems Inc. ( http://www.perpetualmotion.ca )
'
' Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated 
' documentation files (the "Software"), to deal in the Software without restriction, including without limitation 
' the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and 
' to permit persons to whom the Software is furnished to do so, subject to the following conditions:
'
' The above copyright notice and this permission notice shall be included in all copies or substantial portions 
' of the Software.
'
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED 
' TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
' THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF 
' CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
' DEALINGS IN THE SOFTWARE.
'

Imports System.IO
Imports System.Web
Imports DotNetNuke.Entities.Portals
Imports DotNetNuke.Common
Imports DotNetNuke.Framework.Providers

Imports InterAKT.WebControls.Ktml

Namespace DotNetNuke.HtmlEditor

    ''' -----------------------------------------------------------------------------
    ''' Class:  TextEditor
    ''' Project: Provider.Ktml4HtmlEditorProvider
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Ktml4HtmlEditorProvider implements an Html Editor Provider for KTML 4.
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[dge]	01/05/2006	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Class Ktml4HtmlEditorProvider
        Inherits DotNetNuke.Modules.HTMLEditorProvider.HtmlEditorProvider

        Dim cntlKtml As New InterAKT.WebControls.Ktml

        Private Const ProviderType As String = "htmlEditor"

        Private _AdditionalToolbars As New ArrayList
        Private _RootImageDirectory As String
        Private _ControlID As String
        Private _providerConfiguration As ProviderConfiguration = ProviderConfiguration.GetProviderConfiguration(ProviderType)
        Private _providerPath As String

        Private _documentsFolder As String
        Private _mediaFolder As String
        Private _templatesFolder As String

#Region " Provider "

        Public Sub New()

            Dim _portalSettings As PortalSettings = DotNetNuke.Entities.Portals.PortalController.GetCurrentPortalSettings
            ' Read the configuration specific information for this provider
            Dim objProvider As Provider = CType(_providerConfiguration.Providers(_providerConfiguration.DefaultProvider), Provider)

            _providerPath = objProvider.Attributes("providerPath")

            _documentsFolder = objProvider.Attributes("documentsFolder")
            _mediaFolder = objProvider.Attributes("mediaFolder")
            _templatesFolder = objProvider.Attributes("templatesFolder")
        End Sub


        Public ReadOnly Property ProviderPath() As String
            Get
                Return _providerPath
            End Get
        End Property

#End Region

#Region "Properties "

        Public Overrides ReadOnly Property HtmlEditorControl() As System.Web.UI.Control
            Get
                Return cntlKtml
            End Get
        End Property

        Public Overrides Property Text() As String
            Get
                Text = cntlKtml.Text
            End Get
            Set(ByVal Value As String)
                cntlKtml.Text = Value
            End Set
        End Property

        Public Overrides Property ControlID() As String
            Get
                ControlID = _ControlID
            End Get
            Set(ByVal Value As String)
                _ControlID = Value
            End Set
        End Property

        Public Overrides Property AdditionalToolbars() As ArrayList
            Get
                Return _AdditionalToolbars
            End Get
            Set(ByVal Value As ArrayList)
                _AdditionalToolbars = Value
            End Set
        End Property

        Public Overrides Property RootImageDirectory() As String
            Get
                If _RootImageDirectory = "" Then
                    Dim _portalSettings As PortalSettings = DotNetNuke.Entities.Portals.PortalController.GetCurrentPortalSettings

                    If Common.Globals.ApplicationPath <> "" Then
                        'Remove the Application Path from the Home Directory
                        RootImageDirectory = _portalSettings.HomeDirectory.Replace(Common.Globals.ApplicationPath, "")
                    Else
                        RootImageDirectory = _portalSettings.HomeDirectory
                    End If
                Else
                    RootImageDirectory = _RootImageDirectory
                End If

            End Get
            Set(ByVal Value As String)
                _RootImageDirectory = Value
            End Set
        End Property

        Public Overrides Property Width() As System.Web.UI.WebControls.Unit
            Get
                Width = cntlKtml.Width
            End Get
            Set(ByVal Value As System.Web.UI.WebControls.Unit)
                cntlKtml.Width = Value
            End Set
        End Property

        Public Overrides Property Height() As System.Web.UI.WebControls.Unit
            Get
                Height = cntlKtml.Height
            End Get
            Set(ByVal Value As System.Web.UI.WebControls.Unit)
                cntlKtml.Height = Value
            End Set
        End Property

#End Region


#Region "Public Methods"

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' 
        ''' </summary>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Overrides Sub AddToolbar()

        End Sub

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Initialises the control
        ''' </summary>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[dge]	1/05/2006	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Overrides Sub Initialize()
            'initialize the control
            cntlKtml.IncludesUrl = "~/Providers/HtmlEditorProviders/Ktml4HtmlEditorProvider/"
            cntlKtml.ConfigFile = "~/Providers/HtmlEditorProviders/Ktml4HtmlEditorProvider/includes/ktm/ktml4.config.xml"

            If _documentsFolder Is Nothing Then
                cntlKtml.DocumentsFolder = "~" & RootImageDirectory
            Else
                cntlKtml.DocumentsFolder = _documentsFolder
            End If


            If _mediaFolder Is Nothing Then
                cntlKtml.MediaFolder = cntlKtml.DocumentsFolder
            Else
                cntlKtml.MediaFolder = _mediaFolder
            End If

            If _templatesFolder Is Nothing Then
                cntlKtml.TemplatesFolder = cntlKtml.DocumentsFolder
            Else
                cntlKtml.TemplatesFolder = _templatesFolder
            End If
        End Sub

#End Region

    End Class

End Namespace
