# -*- coding: utf-8 -*-

require 'oktest'
require 'skeema'


Oktest.scope do


  topic Skeema::Util::CommandOptionDefinition do

    klass = Skeema::Util::CommandOptionDefinition
    errclass = Skeema::Util::CommandOptionDefinitionError


    topic '.new()' do

      spec "parses definition string of short and long options without arg." do
        [
          "-h, --help: show help",
          "-h,--help: show help",
          "-h, --help :   show help ",
        ].each do |defstr|
          x = klass.new(defstr)
          ok {x.short} == 'h'
          ok {x.long}  == 'help'
          ok {x.name}  == 'help'
          ok {x.arg}   == nil
          ok {x.help}  == 'show help'
          ok {x.arg_required} == false
        end
      end

      spec "parses definition string of short and long options with required arg." do
        [
          "-a, --action=name: action name.",
          "-a,--action=name: action name.",
          "-a,   --action=name  :  action name. ",
        ].each do |defstr|
          x = klass.new(defstr)
          ok {x.short} == 'a'
          ok {x.long}  == 'action'
          ok {x.name}  == 'action'
          ok {x.arg}   == 'name'
          ok {x.help}  == 'action name.'
          ok {x.arg_required} == true
        end
      end

      spec "parses definition string of short and long options with optional arg." do
        [
          "-i, --indent[=N]: indent depth (default 2).",
          "-i,--indent[=N]: indent depth (default 2).",
          "-i,  --indent[=N]  :  indent depth (default 2). ",
        ].each do |defstr|
          x = klass.new(defstr)
          ok {x.short} == 'i'
          ok {x.long}  == 'indent'
          ok {x.name}  == 'indent'
          ok {x.arg}   == 'N'
          ok {x.help}  == 'indent depth (default 2).'
          ok {x.arg_required} == nil
        end
      end

      spec "parses definition string of short-only options without arg." do
        [
          "-q: be quiet",
          "-q  :   be quiet ",
        ].each do |defstr|
          x = klass.new(defstr)
          ok {x.short} == 'q'
          ok {x.long}  == nil
          ok {x.name}  == 'q'
          ok {x.arg}   == nil
          ok {x.help}  == 'be quiet'
          ok {x.arg_required} == false
        end
      end

      spec "parses definition string of short-only options with required arg." do
        [
          "-a name: action name.",
          "-a  name  :  action name. ",
        ].each do |defstr|
          x = klass.new(defstr)
          ok {x.short} == 'a'
          ok {x.long}  == nil
          ok {x.name}  == 'a'
          ok {x.arg}   == 'name'
          ok {x.help}  == 'action name.'
          ok {x.arg_required} == true
        end
      end

      spec "parses definition string of short-only options with optional arg." do
        [
          "-i[N]: indent depth (default 2).",
          "-i[N]  :  indent depth (default 2). ",
        ].each do |defstr|
          x = klass.new(defstr)
          ok {x.short} == 'i'
          ok {x.long}  == nil
          ok {x.name}  == 'i'
          ok {x.arg}   == 'N'
          ok {x.help}  == 'indent depth (default 2).'
          ok {x.arg_required} == nil
        end
      end

      spec "parses definition string of long-only options without arg." do
        [
          "--verbose: be verbose",
          "--verbose  :  be verbose ",
        ].each do |defstr|
          x = klass.new(defstr)
          ok {x.short} == nil
          ok {x.long}  == 'verbose'
          ok {x.name}  == 'verbose'
          ok {x.arg}   == nil
          ok {x.help}  == 'be verbose'
          ok {x.arg_required} == false
        end
      end

      spec "parses definition string of long-only options with required arg." do
        [
          "--action=name: action name.",
          "--action=name  :  action name. ",
        ].each do |defstr|
          x = klass.new(defstr)
          ok {x.short} == nil
          ok {x.long}  == 'action'
          ok {x.name}  == 'action'
          ok {x.arg}   == 'name'
          ok {x.help}  == 'action name.'
          ok {x.arg_required} == true
        end
      end

      spec "parses definition string of long-only options with optional arg." do
        [
          "--indent[=N]: indent depth (default 2).",
          "--indent[=N]  :  indent depth (default 2). ",
        ].each do |defstr|
          x = klass.new(defstr)
          ok {x.short} == nil
          ok {x.long}  == 'indent'
          ok {x.name}  == 'indent'
          ok {x.arg}   == 'N'
          ok {x.help}  == 'indent depth (default 2).'
          ok {x.arg_required} == nil
        end
      end

      spec "detects '#name' notation to override option name." do
        #
        [
          "-h #usage : show usage.",
        ].each do |defstr|
          x = klass.new(defstr)
          ok {x.short} == 'h'
          ok {x.long}  == nil
          ok {x.name}  == 'usage'
          ok {x.arg}   == nil
          ok {x.help}  == 'show usage.'
          ok {x.arg_required} == false
        end
        #
        [
          "-h, --help  #usage : show usage.",
        ].each do |defstr|
          x = klass.new(defstr)
          ok {x.short} == 'h'
          ok {x.long}  == 'help'
          ok {x.name}  == 'usage'
          ok {x.arg}   == nil
          ok {x.help}  == 'show usage.'
          ok {x.arg_required} == false
        end
        #
        [
          "--help  #usage : show usage.",
        ].each do |defstr|
          x = klass.new(defstr)
          ok {x.short} == nil
          ok {x.long}  == 'help'
          ok {x.name}  == 'usage'
          ok {x.arg}   == nil
          ok {x.help}  == 'show usage.'
          ok {x.arg_required} == false
        end
        #
        [
          "-a name #command : action name.",
        ].each do |defstr|
          x = klass.new(defstr)
          ok {x.short} == 'a'
          ok {x.long}  == nil
          ok {x.name}  == 'command'
          ok {x.arg}   == 'name'
          ok {x.help}  == 'action name.'
          ok {x.arg_required} == true
        end
        #
        [
          "--action=name #command : action name.",
        ].each do |defstr|
          x = klass.new(defstr)
          ok {x.short} == nil
          ok {x.long}  == 'action'
          ok {x.name}  == 'command'
          ok {x.arg}   == 'name'
          ok {x.help}  == 'action name.'
          ok {x.arg_required} == true
        end
        #
        [
          "-i, --indent[=N] #width : indent width (default 2).",
        ].each do |defstr|
          x = klass.new(defstr)
          ok {x.short} == 'i'
          ok {x.long}  == 'indent'
          ok {x.name}  == 'width'
          ok {x.arg}   == 'N'
          ok {x.help}  == 'indent width (default 2).'
          ok {x.arg_required} == nil
        end
        #
        [
          "-i[N] #width : indent width (default 2).",
        ].each do |defstr|
          x = klass.new(defstr)
          ok {x.short} == 'i'
          ok {x.long}  == nil
          ok {x.name}  == 'width'
          ok {x.arg}   == 'N'
          ok {x.help}  == 'indent width (default 2).'
          ok {x.arg_required} == nil
        end
        #
        [
          "--indent[=N] #width : indent width (default 2).",
        ].each do |defstr|
          x = klass.new(defstr)
          ok {x.short} == nil
          ok {x.long}  == 'indent'
          ok {x.name}  == 'width'
          ok {x.arg}   == 'N'
          ok {x.help}  == 'indent width (default 2).'
          ok {x.arg_required} == nil
        end
      end

      spec "raises error when failed to parse definition string." do
        pr = proc { klass.new("-h, --help:show help") }
        ok {pr}.raise?(errclass, "'-h, --help:show help': invalid definition.")
      end

    end


  end


  topic Skeema::Util::CommandOptionParser do

    klass = Skeema::Util::CommandOptionParser
    errclass = Skeema::Util::CommandOptionError


    topic '#add()' do

      spec "[!tm89j] parses definition string and adds optdef object." do
        parser = klass.new
        parser.add("-h, --help: show help")
        parser.add("-a, --action=name: action name.")
        ok {parser.optdefs.length} == 2
        ok {parser.optdefs[0].short} == 'h'
        ok {parser.optdefs[0].long}  == 'help'
        ok {parser.optdefs[0].arg}   == nil
        ok {parser.optdefs[1].short} == 'a'
        ok {parser.optdefs[1].long}  == 'action'
        ok {parser.optdefs[1].arg}   == 'name'
      end

      spec "[!00kvl] returns self." do
        parser = klass.new
        ret = parser.add("-h, --help: show help")
        ok {ret}.same?(parser)
      end

    end


    topic '#parse()' do

      fixture :parser do
        parser = klass.new
        parser.add("-h, --help        : show help")
        parser.add("-V   #version     : show version")
        parser.add("-a, --action=name : action name")
        parser.add("-i, --indent[=N]  : indent width (default N=2)")
        parser
      end

      spec "returns options parsed." do
        |parser|
        args = "-hVi4 -a print foo bar".split(' ')
        options = parser.parse(args)
        ok {options} == {'help'=>true, 'version'=>true, 'indent'=>'4', 'action'=>'print'}
        ok {args} == ["foo", "bar"]
      end

      spec "parses short options." do
        |parser|
        # short options
        args = "-hVi4 -a print foo bar".split(' ')
        options = parser.parse(args)
        ok {options} == {'help'=>true, 'version'=>true, 'indent'=>'4', 'action'=>'print'}
        ok {args} == ["foo", "bar"]
        #
        args = "-hi foo bar".split(' ')
        options = parser.parse(args)
        ok {options} == {'help'=>true, 'indent'=>true}
        ok {args} == ["foo", "bar"]
      end

      spec "parses long options." do
        |parser|
        # long options
        args = "--help --action=print --indent=4 foo bar".split(' ')
        options = parser.parse(args)
        ok {options} == {'help'=>true, 'indent'=>'4', 'action'=>'print'}
        ok {args} == ["foo", "bar"]
        #
        args = "--indent foo bar".split(' ')
        options = parser.parse(args)
        ok {options} == {'indent'=>true}
        ok {args} == ["foo", "bar"]
      end

      spec "[!2jo9d] stops to parse options when '--' found." do |parser|
        args = ["-h", "--", "-V", "--action=print", "foo", "bar"]
        options = parser.parse(args)
        ok {options} == {'help'=>true}
        ok {args} == ["-V", "--action=print", "foo", "bar"]
      end

      spec "[!7pa2x] raises error when invalid long option." do |parser|
        pr1 = proc { parser.parse(["--help?", "aaa"]) }
        ok {pr1}.raise?(errclass, "--help?: invalid option format.")
        pr2 = proc { parser.parse(["---help", "aaa"]) }
        ok {pr2}.raise?(errclass, "---help: invalid option format.")
      end

      spec "[!sj0cv] raises error when unknown long option." do |parser|
        pr = proc { parser.parse(["--foobar", "aaa"]) }
        ok {pr}.raise?(errclass, "--foobar: unknown option.")
      end

      spec "[!a7qxw] raises error when argument required but not provided." do |parser|
        pr = proc { parser.parse(["--action", "foo", "bar"]) }
        ok {pr}.raise?(errclass, "--action: argument required.")
      end

      spec "[!8eu9s] raises error when option takes no argument but provided." do |parser|
        pr = proc { parser.parse(["--help=true", "foo", "bar"]) }
        ok {pr}.raise?(errclass, "--help=true: unexpected argument.")
      end

      spec "[!dtbdd] uses option name instead of long name when option name specified." do |parser|
        pr = proc { parser.parse(["--help=true", "foo", "bar"]) }
        ok {pr}.raise?(errclass, "--help=true: unexpected argument.")
      end

      spec "[!7mp75] sets true as value when argument is not provided." do |parser|
        args = ["--help", "foo", "bar"]
        options = parser.parse(args)
        ok {options} == {'help'=>true}
        ok {args} == ["foo", "bar"]
      end

      spec "[!8aaj0] raises error when unknown short option provided." do |parser|
        args = ["-hxV", "foo"]
        pr = proc { parser.parse(args) }
        ok {pr}.raise?(errclass, "-x: unknown option.")
      end

      case_when "[!mnwxw] when short option takes no argument..." do

        spec "[!8atm1] sets true as value." do |parser|
          args = ["-hV", "foo", "bar"]
          options = parser.parse(args)
          ok {options} == {'help'=>true, 'version'=>true}
          ok {args} == ["foo", "bar"]
        end

      end

      case_when "[!l5mee] when short option takes required argument..." do

        spec "[!crvxx] uses following string as argument." do |parser|
          [
            ["-aprint", "foo", "bar"],
            ["-a", "print", "foo", "bar"],
          ].each do |args|
            options = parser.parse(args)
            ok {options} == {'action'=>'print'}
            ok {args} == ["foo", "bar"]
          end
        end

        spec "[!7t6l3] raises error when no argument provided." do |parser|
          pr = proc { parser.parse(["-a"]) }
          ok {pr}.raise?(errclass, "-a: argument required.")
        end

      end

      case_when "[!pl97z] when short option takes optional argument..." do

        spec "[!4k3zy] uses following string as argument if provided." do |parser|
          args = ["-hi4", "foo", "bar"]
          options = parser.parse(args)
          ok {options} == {'help'=>true, 'indent'=>'4'}
          ok {args} == ["foo", "bar"]
        end

        spec "[!9k2ip] uses true as argument value if not provided." do |parser|
          args = ["-hi", "foo", "bar"]
          options = parser.parse(args)
          ok {options} == {'help'=>true, 'indent'=>true}
          ok {args} == ["foo", "bar"]
        end

      end

      spec "[!35eof] returns parsed options." do |parser|
        [
          ["-hVi4", "--action=print", "foo", "bar"],
          ["--indent=4", "-hVa", "print", "foo", "bar"],
        ].each do |args|
          options = parser.parse(args)
          ok {options} == {'help'=>true, 'version'=>true, 'indent'=>'4', 'action'=>'print'}
          ok {args} == ["foo", "bar"]
        end
      end

    end


  end


end