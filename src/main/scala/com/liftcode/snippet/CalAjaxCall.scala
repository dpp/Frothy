/*
 * YakScript.scala
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.liftcode.snippet

import net.liftweb._
import http._
import js._
import JsCmds._
import JE._
import util._
import Helpers._

import scala.xml._

object JsonVar extends SessionVar(S.functionLifespan(true){S.buildJsonFunc{
      case JsonCmd("hello", _, s: String, _) =>
        JsRaw("""
             ajaxCallback("""+("at: "+now+" we got "+s).encJs+""");
            """)

      case x =>
        println("Got x via json: "+x)
        Noop
    }
  })

class CapAjaxCall {
  def render(in: NodeSeq): NodeSeq = Script(
    Function("performAjaxCall", List("param"), JsonVar.is._1("hello", JsVar("param"))) &
    JsonVar.is._2)
}
