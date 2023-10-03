# tara - timesharing application remote access
A S/370 VTAM application

TARA is a program written in the mid-1980s that allowed users of an MVS mainframe system to access applications running on "other" (i.e. non-IBM) systems. This sounds fairly bland today, but back then, it wasn't easy to do "internetworking" between IBM and non-IBM systems.

You almost certainly won't be able to successfully compile this code, and even if you could you certainly woudn't be able to get it to work, since it requires ACF/VTAM, ACF/NCP, and NPSI to do its thing. But I offer it nonetheless as a non-trivial example of System/370 assembly language programming, including macros. 

Macro programming in S/370 assembly language was immensely powerful. Macros were used to "generate" an operating system customized for the user's computing system. The examples here are trivial in comparison, but still give some idea of the sophistication of the macro language.