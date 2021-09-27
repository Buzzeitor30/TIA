/*  $Header: /dist/CVS/fzclips/src/prcdrpsr.h,v 1.3 2001/08/11 21:07:29 dave Exp $  */

   /*******************************************************/
   /*      "C" Language Integrated Production System      */
   /*                                                     */
   /*             CLIPS Version 6.05  04/09/97            */
   /*                                                     */
   /*       PROCEDURAL FUNCTIONS PARSER HEADER FILE       */
   /*******************************************************/

/*************************************************************/
/* Purpose:                                                  */
/*                                                           */
/* Principal Programmer(s):                                  */
/*      Gary D. Riley                                        */
/*      Brian L. Donnell                                     */
/*                                                           */
/* Contributing Programmer(s):                               */
/*                                                           */
/* Revision History:                                         */
/*                                                           */
/*************************************************************/

#ifndef _H_prcdrpsr

#define _H_prcdrpsr

#ifndef _H_constrnt
#include "constrnt.h"
#endif

#ifdef LOCALE
#undef LOCALE
#endif

#ifdef _PRCDRPSR_SOURCE
#define LOCALE
#else
#define LOCALE extern
#endif

struct BindInfo
  {
   struct symbolHashNode *name;
   CONSTRAINT_RECORD *constraints;
   struct BindInfo *next;
  };

#if (! RUN_TIME)
   LOCALE void                           ProceduralFunctionParsers(void);
   LOCALE struct BindInfo               *GetParsedBindNames(void);
   LOCALE void                           SetParsedBindNames(struct BindInfo *);
   LOCALE void                           ClearParsedBindNames(void);
   LOCALE BOOLEAN                        ParsedBindNamesEmpty(void);
#endif
#if (! BLOAD_ONLY) && (! RUN_TIME)
   LOCALE int                            SearchParsedBindNames(struct symbolHashNode *);
   LOCALE int                            CountParsedBindNames(void);
   LOCALE void                           RemoveParsedBindName(struct symbolHashNode *);
   LOCALE struct constraintRecord       *FindBindConstraints(struct symbolHashNode *);
#endif

#endif






